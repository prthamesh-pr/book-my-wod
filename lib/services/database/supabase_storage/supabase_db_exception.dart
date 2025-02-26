class SupabaseDBExceptions implements Exception {
  final String? message;
  final String? details;

  const SupabaseDBExceptions({
    this.message,
    this.details,
  });
}

class CouldNotCreateUserException extends SupabaseDBExceptions {
  CouldNotCreateUserException({
    super.message,
    super.details,
  });
}

class CouldNotGetAllUsersException extends SupabaseDBExceptions {
  CouldNotGetAllUsersException({
    super.message,
    super.details,
  });
}

class CouldNotGetAllAdminUsersException extends SupabaseDBExceptions {
  CouldNotGetAllAdminUsersException({
    super.message,
    super.details,
  });
}

class CouldNotGetUserException extends SupabaseDBExceptions {
  CouldNotGetUserException({
    super.message,
    super.details,
  });
}

class CouldNotUpdateUserException extends SupabaseDBExceptions {
  CouldNotUpdateUserException({
    super.message,
    super.details,
  });
}

class CouldNotDeleteUserException extends SupabaseDBExceptions {
  CouldNotDeleteUserException({
    super.message,
    super.details,
  });
}

class GenericDbException extends SupabaseDBExceptions {
  GenericDbException(String message) : super(message: message);

  @override
  String toString() => message ?? 'GenericDbException';
}

class CouldNotCreateCatagoryException extends SupabaseDBExceptions {
  CouldNotCreateCatagoryException({
    super.message,
    super.details,
  });
}

class CouldNotGetAllCatagoryException extends SupabaseDBExceptions {
  CouldNotGetAllCatagoryException({
    super.message,
    super.details,
  });
}

class CouldNotGetCatagoryException extends SupabaseDBExceptions {
  CouldNotGetCatagoryException({
    super.message,
    super.details,
  });
}

class CouldNotUpdateCatagoryException extends SupabaseDBExceptions {
  CouldNotUpdateCatagoryException({
    super.message,
    super.details,
  });
}

class CouldNotDeleteCatagoryException extends SupabaseDBExceptions {
  CouldNotDeleteCatagoryException({
    super.message,
    super.details,
  });
}

class CouldNotCreateGymException extends SupabaseDBExceptions {
  CouldNotCreateGymException({
    super.message,
    super.details,
  });
}

class CouldNotGetAllGymException extends SupabaseDBExceptions {
  CouldNotGetAllGymException({
    super.message,
    super.details,
  });
}

class CouldNotGetGymException extends SupabaseDBExceptions {
  CouldNotGetGymException({
    super.message,
    super.details,
  });
}

class CouldNotUpdateGymException extends SupabaseDBExceptions {
  CouldNotUpdateGymException({
    super.message,
    super.details,
  });
}

class CouldNotDeleteGymException extends SupabaseDBExceptions {
  CouldNotDeleteGymException({
    super.message,
    super.details,
  });
}

class CouldNotCreateGymCatagoryException extends SupabaseDBExceptions {
  CouldNotCreateGymCatagoryException({
    super.message,
    super.details,
  });
}

class CouldNotGetAllGymCatagoryException extends SupabaseDBExceptions {
  CouldNotGetAllGymCatagoryException({
    super.message,
    super.details,
  });
}

class CouldNotCreateSessionException extends SupabaseDBExceptions {
  CouldNotCreateSessionException({
    super.message,
    super.details,
  });
}

class CouldNotGetAllSessionsException extends SupabaseDBExceptions {
  CouldNotGetAllSessionsException({
    super.message,
    super.details,
  });
}

class CouldNotGetSessionException extends SupabaseDBExceptions {
  CouldNotGetSessionException({
    super.message,
    super.details,
  });
}

class CouldNotUpdateSessionException extends SupabaseDBExceptions {
  CouldNotUpdateSessionException({
    super.message,
    super.details,
  });
}

class CouldNotDeleteSessionException extends SupabaseDBExceptions {
  CouldNotDeleteSessionException({
    super.message,
    super.details,
  });
}

class CouldNotCreateTrainerException extends SupabaseDBExceptions {
  CouldNotCreateTrainerException({
    super.message,
    super.details,
  });
}

class CouldNotGetAllTrainersException extends SupabaseDBExceptions {
  CouldNotGetAllTrainersException({
    super.message,
    super.details,
  });
}

class CouldNotGetTrainerException extends SupabaseDBExceptions {
  CouldNotGetTrainerException({
    super.message,
    super.details,
  });
}

class CouldNotUpdateTrainerException extends SupabaseDBExceptions {
  CouldNotUpdateTrainerException({
    super.message,
    super.details,
  });
}

class CouldNotDeleteTrainerException extends SupabaseDBExceptions {
  CouldNotDeleteTrainerException({
    super.message,
    super.details,
  });
}
