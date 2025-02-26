class ModelConstant {
  // user
  static const id = 'id';
  static const profileAvatar = 'avatar_url';
  static const name = 'full_name';

  // trainer
  static const trainerIdPk = 'id';
  static const authId = 'auth_id';
  static const gymId = 'gym_id';
  static const trainerName = 'name';
  static const trainerStatus = 'status';
  static const trainerRole = 'roles';
  static const userName = 'user_name';
  static const features = 'features';
  static const phoneNumber = 'phone_number';
  static const avatarUrl = 'images';
  static const about = 'about';
  static const createdAt = 'created_at';
  static const updatedAt = 'updated_at';

  // admin
  static const isEnabled = 'isEnabled';
  static const adminId = 'id';
  static const userId = 'uid';

  // gym
  static const gymIdPK = 'id';
  static const gymName = 'name';
  static const gymAddress = 'address';
  static const gymCreatedAt = 'created_at';
  static const gymUpdatedAt = 'updated_at';
  static const gymTheme = 'theme';

  // category
  static const catagoryIdPk = 'id';
  static const categoryName = 'name';
  static const categoryImage = 'image';
  static const categoryCreatedAt = 'created_at';
  static const categoryUpdatedAt = 'updated_at';
  static const uuidOfCatagoryCreator = 'created_by';
  static const gymIdOfCategory = 'gym_id';
  static const categoryFeatures = 'features';

  // sessions
  static const sessionIdPk = 'id';
  static const sessionName = 'name';
  static const sessionDescription = 'description';
  static const sessionImage = 'cover_image';
  static const catagoryId = 'category_id';
  static const timeSlots = 'time';
  static const daysList = 'days';
  static const sessionRepeat = 'session_repeat';
  static const entryLimit = 'entry_limit';
  static const sessionCreatedBy = 'created_by';
  static const sessionCreatedAt = 'created_at';
  static const sessionUpdatedAt = 'updated_at';
  static const gymIdOfSessions = 'gym_id';
}
