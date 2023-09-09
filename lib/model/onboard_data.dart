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
          'Welcome to our mobile app, commemorating seven years of academic brilliance, innovation, and community spirit at NSBM Green University Sri Lanka.'),
  OnBoarding(
      title: 'Your Gateway to a Vibrant Campus Experience',
      image: 'assets/NSBM.jpeg',
      description:
          'As one family, connect, engage, and interact with students, alumni, faculty, and staff who share your passion for knowledge and personal growth.'),
  OnBoarding(
      title: 'NReach',
      image: 'assets/nsbm_nreach.png',
      description:
          'Say hello to NReach, a feature-packed app condensing the entire NSBM Green University ecosystem into one powerful platform.')
];
