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
      title: 'Tìm kiếm công việc',
      discription:
          'Tìm kiếm những công việc phù hợp với khả năng của bạn kết nối và tương tác giữa nhà tuyền dụng và người tìm việc khắp cả nước'),
  OnBoaringJob(
      index: 1,
      image: 'assets/images/onboaring/job2.png',
      title: 'Chia sẻ, thảo luận, hỏi đáp',
      discription:
          'Không chỉ tạo nên một không gian tìm việc truyền thống mà nơi đây chúng ta có thể chia sẻ những kinh nghiệm, thảo luận, hỏi đáp về công việc mình đang quan tâm.'),
  OnBoaringJob(
      index: 2,
      image: 'assets/images/onboaring/job4.png',
      title: 'Ứng tuyển nhanh chóng',
      discription: 'Bạn có thể ứng tuyển một cách nhanh chóng '),
  OnBoaringJob(
      index: 3,
      image: 'assets/images/onboaring/job3.png',
      title: 'Luôn đồng hành cùng bạn',
      discription:
          'Chúng tôi sẽ đồng hành cùng bạn trong quá trình tìm kiếm việc làm'),
];
