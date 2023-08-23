class OnBoarding {
  final String title;
  final String description;
  final String image;

  OnBoarding({
    required this.title,
    required this.image,
    required this.description,
  });
}

// ignore: non_constant_identifier_names
List<OnBoarding> OnBoardingContents = [
  OnBoarding(
      title: 'Celebrating 7 Years of Excellence',
      image: 'assets/7-Year-Anniversary.png',
      description:
          'Welcome to our special mobile app commemorating seven years of academic brilliance, innovation, and community spirit at NSBM Green University Sri Lanka.'),
  OnBoarding(
      title: 'Your Gateway to a Vibrant Campus Experience',
      image: 'assets/NSBM.jpeg',
      description:
          'With this app, we bring the entire NSBM family together on a single platform. Connect, engage, and interact with students, alumni, faculty, and staff who share your passion for knowledge and personal growth.'),
  OnBoarding(
      title: 'Empowering Your NSBM Journey',
      image: 'assets/nsbmlogo.png',
      description:
          'Get ready to unlock a world of possibilities tailored just for you!'),
  OnBoarding(
      title: 'NReach',
      image: 'assets/nreach.png',
      description:
          'Say hello to nReach, your ultimate companion for an enriched NSBM experience! This feature-packed app condenses the entire NSBM Green University Sri Lanka ecosystem into one powerful platform. Whether you’re a student, faculty member, or part of the esteemed alumni network, nReach has something special in store for you!')
];
