// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get changeTheme => 'Mudar a Cor do Tema';

  @override
  String get feedback => 'Feedback e Sugestões';

  @override
  String get changeLanguage => 'Mudar Idioma';

  @override
  String get allFriendsTitle => 'Todos os Amigos';

  @override
  String get noFriendsMessage => 'Você ainda não tem nenhum amigo.';

  @override
  String get unknownCharacter => 'Personagem desconhecido';

  @override
  String errorLoadingFriends(String error) {
    return 'Ocorreu um erro ao carregar a lista de amigos: $error';
  }

  @override
  String get tagGentle => 'Gentil';

  @override
  String get tagCheerful => 'Alegre';

  @override
  String get tagLively => 'Animado';

  @override
  String get tagMischievous => 'Travesso';

  @override
  String get tagRichYoungLady => 'Jovem Dama Rica';

  @override
  String get tagRichYoungMaster => 'Jovem Mestre Rico';

  @override
  String get tagWealthyFamily => 'Família Rica';

  @override
  String get tagScheming => 'Intrigante';

  @override
  String get tagPossessive => 'Possessivo';

  @override
  String get tagParanoid => 'Paranoico';

  @override
  String get tagPersistent => 'Persistente';

  @override
  String get tagUncle => 'Tio';

  @override
  String get tagAuntie => 'Tia';

  @override
  String get tagSeniorSister => 'Irmã Sênior';

  @override
  String get tagJuniorBrother => 'Irmão Júnior';

  @override
  String get tagHandsome => 'Bonito';

  @override
  String get tagStunning => 'Deslumbrante';

  @override
  String get tagContrast => 'Contraste';

  @override
  String get tagFlirty => 'Paquerador';

  @override
  String get tagAgeGap => 'Diferença de Idade';

  @override
  String get userNotFoundError => 'Usuário não encontrado';

  @override
  String get imageDataMismatchError =>
      'Os dados da imagem estão inconsistentes, por favor, selecione a imagem novamente.';

  @override
  String get createCharacterTitle => 'Criar Personagem';

  @override
  String get charAlbumTitle =>
      'Álbum de Personagens (A primeira imagem é o avatar principal)';

  @override
  String get charNameLabel => 'Nome do Personagem:*';

  @override
  String get charDescSection => 'Descrição do Personagem:';

  @override
  String get charAgeLabel => 'Idade:';

  @override
  String get charJobLabel => 'Profissão:*';

  @override
  String get charBirthdayLabel => 'Aniversário:(MMDD)';

  @override
  String get charGenderLabel => 'Gênero *';

  @override
  String get genderNotSelected => 'Não selecionado';

  @override
  String get genderMale => 'Masculino';

  @override
  String get genderFemale => 'Feminino';

  @override
  String get genderOther => 'Outro';

  @override
  String get charHeightLabel => 'Altura:(cm)';

  @override
  String get charAppearanceLabel => 'Descrição da aparência:';

  @override
  String get charPersonalityTagsSection => 'Tags de Personalidade';

  @override
  String get charOtherPersonalityTagsHint => 'Outras tags de personalidade...';

  @override
  String get otherSectionTitle => 'Outro';

  @override
  String get charLikesLabel =>
      'O que gosta:(por exemplo: bolo de morango, gatos, dias de chuva)';

  @override
  String get charDislikesLabel =>
      'O que não gosta:(por exemplo: melão amargo, lugares barulhentos)';

  @override
  String get charSecretsLabel =>
      'Pequenos segredos desconhecidos: (por exemplo: na verdade é uma pessoa sem senso de direção)';

  @override
  String get charMannerismsSection => 'Maneiras e gestos';

  @override
  String get charToneLabel =>
      'Tom e estilo de fala: (por exemplo: frio com estranhos)';

  @override
  String get charDialogueExampleLabel =>
      'Exemplo de diálogo: (Jogador: Você é tão bom! Personagem: ...Oh.)';

  @override
  String get charBackgroundSection => 'Histórico do Personagem:';

  @override
  String get charBackgroundHint =>
      'Insira a história de fundo do personagem (máximo 2500 palavras)';

  @override
  String get charStoryStartSection => 'Início da História:';

  @override
  String get charStoryStartHint =>
      'Insira a trama do personagem (máximo 2500 palavras)';

  @override
  String get charStorySummaryLabel =>
      'Resumo da História (máximo 50 palavras, será exibido no cartão de encontro)';

  @override
  String get charExtraInfoSection => 'Informações Adicionais do Personagem:';

  @override
  String get charExtraInfoHint => 'Insira conteúdo adicional...';

  @override
  String get charPublicToggleLabel =>
      'Tornar público para que outros jogadores possam jogar?';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get createButton => 'Criar';

  @override
  String get saveButton => 'Salvar';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get exitCreationTitle =>
      'Você vai sair da tela de criação de personagem';

  @override
  String get saveDraftPrompt => 'Precisa salvar como rascunho?';

  @override
  String get draftNeeded => 'Sim';

  @override
  String get draftNotNeeded => 'Não';

  @override
  String get editExtraInfoTitle => 'Editar Conteúdo Adicional';

  @override
  String get nameAndAvatarError =>
      'Por favor, preencha o nome do personagem e faça o upload de pelo menos um avatar!';

  @override
  String get savingStatus => 'Salvando...';

  @override
  String get uploadingImagesStatus => 'Fazendo upload das imagens...';

  @override
  String get maxImagesError =>
      'Só é possível fazer upload de no máximo 10 imagens.';

  @override
  String get uploadingImagesStatusShort => 'Processando imagens...';

  @override
  String get savingCharacterData => 'Salvando dados do personagem...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'Personagem \"$charName\" criado!';
  }

  @override
  String get uploadImageTimeoutError =>
      'Falha ao criar o personagem: o upload da imagem expirou, por favor, verifique sua conexão com a internet.';

  @override
  String createCharacterGenericError(String error) {
    return 'Falha ao criar o personagem: $error';
  }

  @override
  String get settingsSectionAppearance => 'Aparência e Conteúdo';

  @override
  String get settingsSectionAccount => 'Gerenciamento de Conta e Conteúdo';

  @override
  String get settingsSectionAbout => 'Sobre Nós';

  @override
  String get accountManagement => 'Gerenciamento de Conta';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'Desconhecido';

  @override
  String get userIdCopied =>
      'ID do usuário copiado para a área de transferência';

  @override
  String get characterManagement => 'Gerenciamento de Personagens';

  @override
  String get viewBlockedCharacters => 'Ver Personagens Bloqueados';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get logoutButton => 'Sair da Conta';

  @override
  String get logoutDialogTitle => 'Você vai sair da conta?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'Eu apertei errado';

  @override
  String get logoutDialogActionConfirm => 'Confirmar';

  @override
  String get logoutSuccessSnackbar =>
      'Ok! Estarei esperando você voltar♥(´∀` )';

  @override
  String get deleteAccountButton => 'Excluir Conta';

  @override
  String get deleteAccountDialogTitle =>
      'Você tem certeza de que deseja excluir esta conta?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'Esta ação é irreversível, todos os dados serão permanentemente excluídos!';

  @override
  String get deleteAccountDialogActionCancel => 'Não, eu não quero excluir';

  @override
  String get deleteAccountDialogActionConfirm => 'Confirmar';

  @override
  String get deleteAccountSuccessSnackbar => 'Conta excluída com sucesso.';

  @override
  String get appDisclaimer =>
      'Os personagens e cenas do jogo são fictícios, por favor, não os aplique na realidade! Se houver alguma semelhança, é pura coincidência.';

  @override
  String appVersion(String version) {
    return 'Versão do Aplicativo: $version';
  }

  @override
  String get dialogTitleHint => 'Dica';

  @override
  String get completeProfilePrompt =>
      'Por favor, edite seu perfil para completar suas informações primeiro!';

  @override
  String get goToEdit => 'Ir para Editar';

  @override
  String get later => 'Mais tarde';

  @override
  String chattingWith(String friendName) {
    return 'Conversando com $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'Conteúdo do chat com $friendName';
  }

  @override
  String get chatInputHint => 'Digite uma mensagem...';
}
