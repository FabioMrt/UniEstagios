class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Busca por Estágios',
      image: 'assets/images/onboarding01.png',
      discription: "Encontre a vaga de estágio ideal para você \n"
          "Receba as melhores oportunidades "
          "para iniciar sua carreira "),
  UnbordingContent(
    title: 'As melhores vagas',
    image: 'assets/images/onboarding02.png',
    discription: "Você terá acesso as melhores oportunidades "
        "de estágio \n disponíveis na sua região ",
  ),
  UnbordingContent(
    title: 'Praticidade ',
    image: 'assets/images/onboarding03.png',
    discription: "Envie seu currículo e candidate-se \n"
        "diretamente pelo aplicativo",
  ),
];
