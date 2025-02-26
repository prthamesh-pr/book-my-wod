import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:bookmywod_admin/bloc/chat_bloc.dart';
import 'package:bookmywod_admin/bloc/events/chat_event.dart';
import 'package:bookmywod_admin/bloc/states/chat_state.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String receiverId;

  const ChatScreen({super.key, required this.userId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();

  bool _isRecording = false;
  bool _showSendButton = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    BlocProvider.of<ChatBloc>(context).add(
      LoadMessages(userId: widget.userId, receiverId: widget.receiverId),
    );
    _audioRecorder.openRecorder();
    _audioPlayer.openPlayer();

    // Listen to text field changes
    _messageController.addListener(() {
      setState(() {
        _showSendButton = _messageController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    if (_audioPlayer.isPlaying) {
      _audioPlayer.stopPlayer();
    }
    _audioPlayer.closePlayer();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(
        SendMessage(
          userId: widget.userId,
          receiverId: widget.receiverId,
          message: _messageController.text,
        ),
      );
      _messageController.clear();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.isGranted) {
        Directory tempDir = Directory.systemTemp;
        String uniqueFileName = "voice_message_${DateTime.now().millisecondsSinceEpoch}.aac";
        String path = "${tempDir.path}/$uniqueFileName";

        await _audioRecorder.startRecorder(toFile: path);
        setState(() {
          _isRecording = true;
          _recordedFilePath = path; // Save the file path
        });
      }
    } catch (e) {
      debugPrint("Recording Error: $e");
    }
  }


  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stopRecorder();
      setState(() => _isRecording = false);
      if (path != null) {
        _sendVoiceMessage(path);
      }
    } catch (e) {
      debugPrint("Stop Recording Error: $e");
    }
  }

  void _sendVoiceMessage(String filePath) {
    BlocProvider.of<ChatBloc>(context).add(
      SendVoiceMessage(
        userId: widget.userId,
        receiverId: widget.receiverId,
        audioPath: filePath,
      ),
    );
  }
  String? _currentlyPlayingFile; // Track currently playing audio

  Future<void> _playVoiceMessage(String filePath) async {
    try {
      if (_audioPlayer.isPlaying) {
        if (_currentlyPlayingFile == filePath) {
          await _audioPlayer.pausePlayer(); // Pause if same file is playing
          setState(() => _currentlyPlayingFile = null);
        } else {
          await _audioPlayer.stopPlayer(); // Stop the previous file
          await _audioPlayer.startPlayer(
            fromURI: filePath,
            whenFinished: () {
              setState(() => _currentlyPlayingFile = null);
            },
          );
          setState(() => _currentlyPlayingFile = filePath);
        }
      } else {
        await _audioPlayer.startPlayer(
          fromURI: filePath,
          whenFinished: () {
            setState(() => _currentlyPlayingFile = null);
          },
        );
        setState(() => _currentlyPlayingFile = filePath);
      }
    } catch (e) {
      debugPrint("Audio Play/Pause Error: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat", style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final bool isCurrentUser =
                          message.senderId == widget.userId;
                      final bool isVoiceMessage =
                          message.message.endsWith(".aac");

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntrinsicWidth(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.8, // Max 80% of screen
                              ),                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
                            
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.blueAccent
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isCurrentUser
                                      ? const Radius.circular(16)
                                      : Radius.zero,
                                  bottomRight: isCurrentUser
                                      ? Radius.zero
                                      : const Radius.circular(16),
                                ),
                              ),
                              child: isVoiceMessage
                                  ?  GestureDetector(
                                onTap: () => _playVoiceMessage(message.message),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _currentlyPlayingFile == message.message ? Icons.pause : Icons.play_arrow,
                                      color: isCurrentUser ? Colors.white : Colors.black,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Voice Message",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isCurrentUser ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )

                              : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.message,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isCurrentUser
                                                ? Colors.black
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            message.getFormattedDate(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isCurrentUser
                                                  ? Colors.black
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text("Error: ${state.error}"));
                }
                return const Center(child: Text("No messages yet."));
              },
            ),
          ),

          // Input Field
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Voice Record Button (if no text)

                // Message Input
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: customGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (!_showSendButton)
                  GestureDetector(
                    onLongPress: _startRecording,
                    onLongPressUp: _stopRecording,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor:
                          _isRecording ? Colors.redAccent : Colors.blueAccent,
                      child: Icon(
                        _isRecording ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Send Button (if text exists)
                if (_showSendButton)
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: Colors.blueAccent, size: 28),
                    onPressed: _sendMessage,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
