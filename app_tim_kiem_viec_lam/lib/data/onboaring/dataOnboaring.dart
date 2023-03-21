class OnBoaringJob {
  int? index;
  String? image;
  String? title;
  String? discription;

  OnBoaringJob({this.index, this.image, this.title, this.discription});
}

List<OnBoaringJob> onBoaringdata = [
  OnBoaringJob(
      index: 0,
      image: 'assets/images/onboaring/job1.png',
      title: 'Search your job',
      discription:
          'Figure out your top five priorities whether it is company culture, salary.'),
  OnBoaringJob(
      index: 1,
      image: 'assets/images/onboaring/job2.png',
      title: 'Browse jobs list',
      discription:
          'Our job list include several  industries, so you can find the best job for you.'),
  OnBoaringJob(
      index: 2,
      image: 'assets/images/onboaring/job4.png',
      title: 'Apply to best jobs',
      discription:
          'You can apply to your desirable jobs very quickly and easily with ease.'),
  OnBoaringJob(
      index: 3,
      image: 'assets/images/onboaring/job3.png',
      title: 'Make your career',
      discription:
          'We help you find your dream job based on your skillset, location, demand.'),
];
