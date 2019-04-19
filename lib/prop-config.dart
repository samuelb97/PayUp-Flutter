import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';

class Prompts {
  static const String type_username = 'Please type a username';
  static const String updateProfile = 'Update Profile';
  static const String updateYourProfile = 'Update Your Profile';
  static const String updateDoc = 'Documented Update';
  static const String login = 'Log In';
  static const String signup = 'Sign Up';
  static const String type_email = 'Please type your email';
  static const String email_verif = 'Email not Verified';
  static const String passwrd = 'Password';
  static const String passwrd2 = 'Confirm Password';
  static const String passwrd_valid =
      'Password must be longer than 6 characters';
  static const String email_err_1 = 'Your email has not been verified ';
  static const String email_err_2 =
      'please click the verification link sent to ';
  static const String name = 'Enter your Full Name';
  static const String age = 'Enter your age';
  static const String occupation = 'Enter your occupation';
  static const String mobileNumber = 'Enter your mobile number';
  static const String editInterests = 'Edit Interests';
  static const String newInterest = 'New Interest';
  static const String support = 'Support';
  static const String meet = 'Meet your Developers!';
  static const String contact = 'Contact us with any questions or concerns';
  static const String dev1 =
      'Bradley Sheehan \n(631) 413-3254 \nbxs388@miami.edu';
  static const String dev2 = 'Samuel Boley \n(202) 997-8226 \nsab132@miami.edu';
  static const String dev3 = 'Justin Moon \n(314) 484-9750 \njsm207@miami.edu';
}

class Buttons {
  static const String moreinfo = 'more info';
  static const String chat = 'chat';
}

class Headers {
  static const String payup = 'PayUp ';
  static const String friends = 'Friends';
  static const String profile = 'Profile';
  static const String username = 'Username';
  static const String email = 'Email';
  static const String close = 'Close';
  static const String resend = 'Resend link';
  static const String messages = 'Messages';
  static const String settings = 'Settings';
  static const String welcomePage = 'Welcome Page';
  static const String search = 'Search';
}

class Path {
  static const String user = 'users/';
}

class Assets {
  static const String image = "assets/background.jpg";
}

class Userinfo {
  static const String fullName = 'Full Name';
  static const String age = 'Age';
  static const String gender = 'Gender';
  static const String gender0 = 'Male';
  static const String gender1 = 'Female';
  static const String gender2 = 'Other';
  static const String username = 'Username';
  static const String mobileNumber = 'Mobile Number';
  static const String update = 'Update';
  static const String userid = 'Your Account ID';
  static const String interests = 'Interests';
  static const String updateProfilePic = "Update Profile Picture";
}

class Pattern {
  static const String integers = r'(^[0-9]*$)';
  static const String characters = r'(^[a-z A-Z]*$)';
}

class Requirements {
  static const String name = 'Name is Required';
  static const String range = 'Name must be a-z and A-Z';
  static const String age = 'Age is Required';
  static const String age_valid = 'Age must be digits';
  static const String gender = 'Gender is required';
  static const String gender_valid = 'Gender must be a-z and A-Z';
  static const String occupation = 'Occupation is Required';
  static const String occupation_valid = 'Occupation must be a-z and A-Z';
  static const String mobile = 'Mobile is Required';
  static const String mobile_valid_1 = 'Mobile numbermust be 10 digits';
  static const String mobile_valid_2 = 'Mobile number must be digits';
}

class Events {
  static const String login = 'login';
  static const String signup = 'signup';

  static const String update = 'toUpdateProfile';
  static const String profileUpdated = 'profile_updated';

  static const String profile = 'nav_to_proflie';
  static const String search = 'nav_to_search';
  static const String buddies = 'nav_to_buddies';
  static const String settings = 'nav_to_settings';

  static const String emailverif = 'email_verification';
  static const String login_success = 'login_successful';

  static const String new_signup = 'new_sign_up';

  static const String searching = 'searching';
  static const String to_settings = 'to_settings';

  static const String to_buddies = 'to_buddies';
}

class Screens {
  static const String welcome = 'welcome_page';
  static const String welcomeOver = 'WelcomePage';

  static const String profile = 'profile_page';
  static const String profileOver = 'ProfileOver';

  static const String updateProfile = 'update_profile_page';
  static const String updateOver = 'UpdateProfileOver';

  static const String login = 'login_page';
  static const String loginOver = 'Login_Over';

  static const String signup = 'signup_page';
  static const String signupOver = 'Signup_Over';

  static const String search = 'search_page';
  static const String searchOver = 'SearchOver';

  static const String buddies = 'buddies_page';
  static const String buddiesOver = 'BuddiesOver';

  static const String settings = 'settings_page';
  static const String settingsOver = 'SettingsOver';
}

class themeColors {
  static Color accent = Colors.green;
  static Color accent4 = Color(0xFF083F1E);
  static Color accent3 = Colors.green[900];
  static Color accent2 = Colors.green[800];
  static Color accent1 = Colors.green[300];
  static Color theme = Colors.blueGrey;
  static Color theme2 = Colors.blueGrey[600];
  static Color theme1 = Colors.blueGrey[300];
  static Color theme0 = Colors.blueGrey[200];
  static Color theme3 = Colors.blueGrey[900];
  static var linearGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: [0.12, 0.64, 0.96],
      colors: [
        // Colors are easy thanks to Flutter's Colors class.
        theme3,
        theme2,
        theme1,
      ],
    ),
  );
  static var linearGradient2 = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: [0.24, 0.84, 0.99],
      colors: [
        // Colors are easy thanks to Flutter's Colors class.
        theme3,
        theme2,
        theme1,
      ],
    ),
  );
}

final GlobalKey<AsyncLoaderState> asyncLoaderState = GlobalKey<AsyncLoaderState>();

