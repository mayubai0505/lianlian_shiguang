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

  @override
  String get characterNotFoundError => 'Dados do personagem não encontrados';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'Falha ao carregar os detalhes do personagem: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'Relacionamento inicial';

  @override
  String get relationship_childhood_friend => 'Amigo de infância';

  @override
  String get relationship_senior_junior => 'Veterano/calouro';

  @override
  String get relationship_bickering_couple => 'Casal que briga';

  @override
  String get relationship_colleagues => 'Colegas de trabalho';

  @override
  String get relationship_other => 'Outro (por favor, insira manualmente)';

  @override
  String get chatModeDaily => 'Modo Diário';

  @override
  String get chatModeStory => 'Modo História';

  @override
  String get chatModeImmersive => 'Modo Imersivo';

  @override
  String get chatModeGemini => 'Companheiro de Vida';

  @override
  String get announcement_new => 'Novo Anúncio';

  @override
  String get mail_notification =>
      'Uma nova Carta do Tempo chegou! Vá verificar o Pergaminho agora!';

  @override
  String get customer_service_reply => 'Resposta do Suporte ao Cliente';

  @override
  String get system_announcement => 'Anúncio do Sistema';

  @override
  String get empty_announcement => 'Nenhum anúncio no momento.';

  @override
  String get untitled => 'Sem Título';

  @override
  String get no_content => 'Sem Conteúdo';

  @override
  String get privacy_policy_title =>
      'Política de Privacidade de Lianlian Shiguang';

  @override
  String get privacy_policy_date => 'Última atualização: 10 de abril de 2026';

  @override
  String get privacy_policy_body =>
      'Política de Privacidade de \"Lianlian Shiguang\"\nÚltima atualização: 10 de abril de 2026\n\nBem-vindo ao \"Lianlian Shiguang\". Valorizamos sua privacidade. Esta política explica como tratamos seus dados.\n\n1. Dados de Conta :\nLogin via Google/Facebook/Apple (UID, e-mail, apelido). O Firebase gerencia senhas criptografadas.\nInteração: Armazenamos diálogos para que a IA mantenha a memória dos personagens.\nDispositivo: Modelo e versão do sistema para otimização.\n\n2. Uso :\nMelhoria da IA, processamento de pagamentos e segurança do servidor.\n\n3. Parceiros :\nGoogle Cloud, Firebase, OpenRouter, xAI, Meta. Não vendemos seus diálogos para publicidade.\n\n4. Exclusão :\nDados seguros na nuvem. Você pode solicitar a exclusão permanente da conta a qualquer momento.';

  @override
  String get terms_title => 'Termos de Serviço de Lianlian Shiguang';

  @override
  String get terms_date => 'Última atualização: 10 de abril de 2026';

  @override
  String get terms_body =>
      'Termos de Uso de \"Lianlian Shiguang\"\nÚltima atualização: 10 de abril de 2026\n\nAo usar o serviço, você concorda com :\n\n1. Natureza da IA :\nRespostas geradas por IA, sem representação humana. Conteúdo pode ser fictício.\n\n2. Pontos Virtuais :\nItens virtuais não reembolsáveis após o uso.\n\n3. Conduta :\nProibido conteúdo violento, ilegal ou interferência no sistema.\n\n4. Propriedade :\nPersonagens oficiais (ex: Cheng An) e lógica pertencem à equipe. Ícones (Google/Apple) sob licença.\n\n5. Rescisão :\nSuspensão de conta em caso de violação das regras.';

  @override
  String get login_required => 'Faça login primeiro';

  @override
  String get cloud_character_mgmt => 'Gestão de Personagens na Nuvem';

  @override
  String get connection_error => 'Erro de Conexão';

  @override
  String get no_characters_met => 'Você ainda não conheceu nenhum personagem!';

  @override
  String get status_paused => 'Status: Contato Pausado';

  @override
  String get status_in_progress => 'Status: Em Progresso';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get block => 'Bloquear';

  @override
  String get confirm_block_title => 'Confirmar bloqueio?';

  @override
  String block_warning_msg(String charName) {
    return 'Após o bloqueio, você não receberá mensagens de $charName temporariamente.';
  }

  @override
  String get think_again => 'Pensar Melhor';

  @override
  String get confirm_block_btn => 'Confirmar Bloqueio';

  @override
  String get no_char_info =>
      'Sem informações detalhadas deste personagem ainda...';

  @override
  String get private_mailbox => 'Caixa de Correio Privada';

  @override
  String get user_info_not_found => 'Informações do usuário não encontradas';

  @override
  String get load_failed => 'Falha ao carregar, tente novamente mais tarde';

  @override
  String get empty_mailbox => 'A caixa de correio está vazia~';

  @override
  String get system_notification => 'Notificação do Sistema';

  @override
  String get interaction_records => 'Histórico de Interação';

  @override
  String get liked_content => 'Conteúdo Curtido';

  @override
  String get my_favorites => 'Meus Favoritos';

  @override
  String get login_to_view_records => 'Faça login para ver o histórico';

  @override
  String get no_likes_yet => 'Você ainda não curtiu nenhuma postagem!';

  @override
  String get empty_favorites =>
      'Sua pasta de favoritos está vazia, explore o Saguão!';

  @override
  String get theme_sakura_pink => 'Rosa Sakura';

  @override
  String get theme_ocean_blue => 'Azul Oceano';

  @override
  String get theme_sunset_orange => 'Laranja Pôr do Sol';

  @override
  String get theme_mint_forest => 'Floresta de Menta';

  @override
  String get theme_midnight => 'Modo Meia-noite';

  @override
  String get change_atmosphere => 'Mudar Ambiente';

  @override
  String get custom_color => 'Cor Personalizada';

  @override
  String get custom_color_desc => 'Crie sua própria cor de ambiente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get confirm_delete_title => 'Confirmar exclusão';

  @override
  String get confirm_delete_memory_msg =>
      'Tem certeza de que quer que ele esqueça isso? Esta ação não pode ser desfeita.';

  @override
  String get delete_btn => 'Excluir';

  @override
  String get memory_erased_msg => 'Esta memória foi apagada.';

  @override
  String get delete_failed_msg => 'Falha na exclusão';

  @override
  String get edit_memory_title => 'Editar lembrança';

  @override
  String get modify_memory_hint => 'Modificar esta memória...';

  @override
  String get memory_re_recorded_msg => 'Memória gravada novamente';

  @override
  String get update_failed_msg => 'Falha na atualização';

  @override
  String get update_favorite_failed_msg =>
      'Falha ao atualizar o status de favorito';

  @override
  String char_notebook_title(String charName) {
    return 'Caderno de $charName';
  }

  @override
  String get error_loading_memory => 'Erro ao carregar a memória';

  @override
  String get empty_notebook_msg =>
      'O caderno está vazio...\nVá conversar para que ele possa escrever tudo sobre você!';

  @override
  String get date_format_text => 'd MMM yyyy';

  @override
  String get remove_special_focus => 'Remover foco especial';

  @override
  String get mark_special_focus => 'Marcar como foco especial';

  @override
  String get edit_btn => 'Editar';

  @override
  String get load_gallery_failed => 'Falha ao carregar a galeria';

  @override
  String get traditional_chinese => 'Chinês Tradicional';

  @override
  String get all => 'Tudo';

  @override
  String get official_recommendation => 'Recomendação Oficial';

  @override
  String get my_exclusive => 'Meu Exclusivo';

  @override
  String encounter_count(int count) {
    return '$count Encontros';
  }

  @override
  String get official => 'Oficial';

  @override
  String get private => 'Privado';

  @override
  String get first_encounter => 'Primeiro Encontro';

  @override
  String char_exclusive_memory(String charName) {
    return 'Memória Exclusiva de $charName';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'O afeto deve atingir $affectionLevel para desbloquear esta memória!';
  }

  @override
  String get affection => 'Afeto';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get change_chat_bg => 'Mudar Fundo do Chat';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return 'Definir \"$cgDesc\" como fundo do chat com $charName?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'Fundo alterado para \"$cgDesc\"';
  }

  @override
  String get confirm_change => 'Confirmar';

  @override
  String get empty_treasure_box =>
      'O baú do tesouro está vazio...\nVá conversar para encontrar segredos escondidos!';

  @override
  String get unknown_story => 'História Desconhecida';

  @override
  String get open_this_memory => 'Abrir esta memória';

  @override
  String get open_exclusive_story => 'Abrir história exclusiva';

  @override
  String confirm_use_egg(String eggTitle) {
    return 'Experimentar \"$eggTitle\" agora?\n\n(Este item é consumível e entrará automaticamente na história após o uso)';
  }

  @override
  String get wait_a_bit => 'Esperar';

  @override
  String guiding_into_story(String eggTitle) {
    return 'Guiando para a história...';
  }

  @override
  String get use_now => 'Usar Agora';

  @override
  String playback_failed_status(String statusCode) {
    return 'Falha na reprodução, código: $statusCode';
  }

  @override
  String get playback_error => 'Ocorreu um erro de reprodução';

  @override
  String get unknown_contact => 'Contato Desconhecido';

  @override
  String call_memory_with(String charName) {
    return 'Memória de Chamada com $charName';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'Desbloqueia com afeição $affection';
  }

  @override
  String get no_call_record =>
      'Parece não haver registro de conversa para esta chamada...';

  @override
  String get me => 'Eu';

  @override
  String get playing => 'Reproduzindo...';

  @override
  String get listen => 'Ouvir';

  @override
  String get no_exclusive_voice =>
      'Esse personagem ainda não possui uma voz exclusiva!';

  @override
  String get voice_download_success =>
      '✅ Dados de voz baixados com sucesso, preparando para reproduzir...';

  @override
  String get onboarding_invitation => '— Convite do Tempo —';

  @override
  String get onboarding_welcome => 'Bem-vinda a Lian Lian Shi Guang';

  @override
  String get onboarding_quote =>
      '\"Todo encontro é um reencontro após uma longa separação.\"';

  @override
  String get onboarding_gift_title =>
      'Presente de Primeiro Encontro: 50 Flores';

  @override
  String get onboarding_gift_subtitle =>
      'Estas flores a acompanharão para começar sua história com ele.';

  @override
  String get onboarding_start_button => 'Comece sua Jornada no Tempo';

  @override
  String get onboarding_more_info => 'Saiba mais sobre a história';

  @override
  String get legal_agreement_prefix => 'Ao continuar, você concorda com nossos';

  @override
  String get legal_terms_button => 'Termos de Serviço';

  @override
  String get legal_and => ' e ';

  @override
  String get legal_privacy_button => 'Política de Privacidade';

  @override
  String get call_memory_title => 'Memórias de Chamadas';

  @override
  String get please_login_first => 'Por favor, faça o login primeiro';

  @override
  String get no_call_memories =>
      'Nenhuma memória de chamada salva ainda.\nNo máximo 10 registros podem ser salvos.';

  @override
  String call_with_name(String name) {
    return 'Chamada com $name';
  }

  @override
  String call_duration(String time) {
    return 'Duração: $time';
  }

  @override
  String get delete_call_title => 'Excluir Registro';

  @override
  String delete_call_confirm(String name) {
    return 'Tem certeza de que deseja excluir esta memória com $name?\n(Não pode ser desfeito)';
  }

  @override
  String get keep_it => 'Manter';

  @override
  String get confirm_delete => 'Excluir';

  @override
  String get press_mic_to_speak =>
      'Pressione o microfone para começar a falar...';

  @override
  String get call_ended => 'Chamada encerrada';

  @override
  String character_thinking(String name) {
    return '($name está pensando...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name está atendendo...)';
  }

  @override
  String get call_interrupted_login =>
      '(Chamada interrompida) Por favor, faça login primeiro...';

  @override
  String get silence => '(Silêncio)';

  @override
  String get bad_signal => '(Sinal ruim...)';

  @override
  String get static_noise => '(Estática)... não consigo ouvir direito...';

  @override
  String get type_message_hint => 'Digite uma mensagem...';

  @override
  String get draft_saved_success =>
      'Rascunho salvo com sucesso no Estúdio Secreto!';

  @override
  String get draft_save_failed => 'Falha ao salvar, tente novamente mais tarde';

  @override
  String get draft_save_title => 'Deseja salvar o rascunho?';

  @override
  String get draft_save_content =>
      'Seu trabalho ainda não foi publicado, deseja salvá-lo no Estúdio Secreto primeiro?';

  @override
  String get not_save => 'Não salvar';

  @override
  String get save_draft => 'Salvar rascunho';

  @override
  String confirm_delete_char_content(String name) {
    return 'Tem certeza de que deseja excluir o personagem \"$name\"?\n\nEsta ação não pode ser desfeita!';
  }

  @override
  String get char_deleted => 'Personagem excluído';

  @override
  String get ok_button => 'Certo!';

  @override
  String get cannot_save_title => 'Não é possível salvar';

  @override
  String get cannot_save_content =>
      'Por favor, preencha o nome do personagem e faça o upload de pelo menos um avatar!';

  @override
  String get word_count_exceeded => 'Limite de palavras excedido';

  @override
  String word_count_error_detail(String field, int limit) {
    return '\"$field\" excedeu o limite de $limit palavras, reduza antes de salvar.';
  }

  @override
  String get content_missing => 'Conteúdo ausente';

  @override
  String get content_missing_personality =>
      'Preencha a \"Personalidade Detalhada\"! Escreva pelo menos 10 palavras.';

  @override
  String get content_missing_bg =>
      'A \"Apresentação do Personagem\" é muito curta! Escreva pelo menos 20 palavras para explicar o contexto.';

  @override
  String get content_missing_tone =>
      'Defina o \"Tom e Hábitos\", caso contrário, será fácil sair do personagem (OOC)!';

  @override
  String get user_not_found => 'Erro: Usuário não encontrado';

  @override
  String char_saved_success(String name, String action) {
    return 'O personagem \"$name\" foi $action!';
  }

  @override
  String save_error_detail(String error) {
    return 'Falha ao salvar: $error';
  }

  @override
  String get easter_egg_add_title => 'Adicionar Easter Egg oculto';

  @override
  String get easter_egg_edit_title => 'Editar Easter Egg';

  @override
  String get keyword_label => 'Palavra-chave de gatilho (obrigatório)';

  @override
  String get keyword_hint => 'Ex: ir ao parque de diversões, bolo de morango';

  @override
  String get egg_title_label => 'Título do Easter Egg (para jogadores)';

  @override
  String get egg_title_hint => 'Ex: Encontro de fim de semana';

  @override
  String get egg_teaser_label => 'Prévia curta (para jogadores)';

  @override
  String get egg_teaser_hint => 'Descreva o início do que vai acontecer...';

  @override
  String get egg_scene_label => 'Mudança de cena forçada (opcional)';

  @override
  String get egg_scene_hint => 'Ex: Parque de diversões, casa mal-assombrada';

  @override
  String get egg_prompt_label => 'Comando de roteiro';

  @override
  String get egg_prompt_hint =>
      'Como atuar nesta trama.\n(Sistema: A cena muda para o parque de diversões, o personagem olha para (nome do jogador) e sorri...)';

  @override
  String get confirm_button => 'Confirmar';

  @override
  String get keyword_empty_error => 'A palavra-chave não pode estar vazia';

  @override
  String get voice_custom_title => 'Personalizar voz exclusiva';

  @override
  String get voice_custom_hint => 'Ex: CEO autoritário, garoto gentil...';

  @override
  String get voice_generate_start => 'Começar a gerar';

  @override
  String get voice_bind_first =>
      'Por favor, selecione e \"vincule\" uma voz exclusiva primeiro!';

  @override
  String get voice_test_failed =>
      'Falha na audição: Clique em \"Eu escolho você!\" para vincular formalmente a voz antes de fazer ajustes finos!';

  @override
  String voice_name_default(String name) {
    return 'Voz exclusiva de $name';
  }

  @override
  String get voice_description_default =>
      'Esta é uma voz única criada para um personagem exclusivo em \"Lian Lian Shi Guang\", selecionada e gerada pelo jogador.';

  @override
  String get voice_bind_failed =>
      'Falha ao vincular voz, verifique a cota da API ou o status da rede';

  @override
  String voice_bind_success(String name) {
    return 'A voz da alma de \"$name\" foi formalmente vinculada!';
  }

  @override
  String get voice_bind_success_draft =>
      'Voz vinculada com sucesso! Agora você pode mover o controle deslizante para testar as emoções!';

  @override
  String sync_failed(String error) {
    return 'Falha na sincronização, verifique a rede: $error';
  }

  @override
  String edit_character_title(String name) {
    return 'Editar $name';
  }

  @override
  String get test_mode_tooltip => 'Teste completo de funções';

  @override
  String get test_mode_error =>
      '⚠️ Arquivo do personagem não encontrado! Clique em \"Salvar/Publicar\" na parte inferior antes de testar!';

  @override
  String get test_mode_notice =>
      '💡 O modo de teste descontará pontos conforme o preço original de cada modo e não contará para as memórias formais!';

  @override
  String get delete_character_tooltip => 'Excluir personagem';

  @override
  String get tab_basic_story => 'Básico e Trama';

  @override
  String get tab_voice => 'Voz Exclusiva';

  @override
  String get tab_relationship => 'Relações Sociais';

  @override
  String get save_changes_button => 'Salvar alterações';

  @override
  String get section_basic_info => 'Dados básicos';

  @override
  String get hint_occupation =>
      'Suporta múltiplas identidades, use barra ou vírgula (Ex: Estudante/Hacker)';

  @override
  String get hint_appearance =>
      'Ex: Cabelo prateado longo, olhos âmbar, sempre usa jaleco branco...';

  @override
  String get section_story_identity => '🎭 Trama e sua identidade';

  @override
  String get story_identity_desc =>
      'Defina o início da história e suas configurações especiais neste save';

  @override
  String get advanced_writing_tips_title => '💡 Dicas de escrita avançada:\n';

  @override
  String get advanced_writing_tips_1 => 'Digite na história ou falas ';

  @override
  String get advanced_writing_tips_2 => '(nome do jogador)';

  @override
  String get advanced_writing_tips_3 =>
      ', o sistema substituirá automaticamente pelo apelido real do jogador durante o jogo!\n';

  @override
  String get advanced_writing_tips_4 => 'Exemplo: \"';

  @override
  String get advanced_writing_tips_5 => '(nome do jogador)';

  @override
  String get advanced_writing_tips_6 => ', por que você chegou tão tarde?\"';

  @override
  String get player_identity_label =>
      'Identidade padrão do jogador (Player Identity) - 💡 Opcional';

  @override
  String get player_identity_hint =>
      '【Opcional】Se vazio, a IA lerá seu \"Perfil\" para interagir.\nSe preenchido, forçará uma identidade específica (Ex: seu sistema frio, ou esposa traída).';

  @override
  String get background_label => 'Histórico e mundo do personagem';

  @override
  String get background_hint =>
      'Descreva o passado e o mundo dele (Ex: cidade moderna, ABO, apocalipse). Ex: É um mundo infestado de zumbis, e ele é o soldado de elite que protege você...';

  @override
  String get story_summary_label => 'Resumo da história em uma frase';

  @override
  String get story_initial_label => 'História do encontro inicial';

  @override
  String get story_initial_hint =>
      'Ex: Você abre a porta e o vê sentado à janela. Ele se vira e diz: \"(nome do jogador), venha cá.\"';

  @override
  String get first_line_label => 'Primeira frase do personagem';

  @override
  String get first_line_hint =>
      'Ex: (nome do jogador), você finalmente chegou.';

  @override
  String get section_personality_evo =>
      '🌟 Evolução de personalidade e afeição';

  @override
  String get detailed_personality_label => 'Personalidade detalhada';

  @override
  String get detailed_personality_hint =>
      'Descreva o núcleo do caráter. Ex: Tsundere, duro por fora e gentil por dentro. Frio com estranhos, sorri apenas para o jogador.';

  @override
  String get affection_evo_desc =>
      'A IA julgará quando aumentar a afeição com base nestas configurações:';

  @override
  String get stage_1_label => 'Estágio 1: Estranho/Alerta (Lv1)';

  @override
  String get stage_1_hint =>
      'Reação ao se conhecerem. Condições de afeição (Ex: cortesia, não invadir a privacidade).';

  @override
  String get stage_2_label => 'Estágio 2: Familiar/Amigo (Lv2)';

  @override
  String get stage_2_hint =>
      'Mudanças após a familiaridade. Condições de afeição (Ex: compartilhar doces, falar sobre gatos).';

  @override
  String get stage_3_label => 'Estágio 3: Íntimo/Amante (Lv3)';

  @override
  String get stage_3_hint =>
      'Reação após se apaixonar completamente. Terá ciúmes? Ou ficará emburrado em silêncio?';

  @override
  String get social_interaction_label => 'Interação social e ambiental';

  @override
  String get social_interaction_hint =>
      'Ex: Como trata estranhos? Como reage a coisas que odeia?';

  @override
  String get section_habits => '🗣️ Gostos e hábitos';

  @override
  String get tone_hint_detail =>
      'Obrigatório. Ex: Fala pouco, gosta de questionar. Seu bordão é \"bobo\". Proibido usar estilo de tradução automática.';

  @override
  String get dialogue_example_hint =>
      'Jogador: Estou cansado.\nPersonagem: (Alisa a cabeça) Seja bom, vá descansar logo.';

  @override
  String get section_easter_eggs => '🎁 Easter Eggs e tramas especiais';

  @override
  String get no_easter_eggs =>
      'Nenhum Easter Egg definido, clique abaixo para adicionar';

  @override
  String get no_scene_change => 'Não mudar cena';

  @override
  String get add_easter_egg_button => 'Adicionar Easter Egg oculto';

  @override
  String get other_extra_info => 'Outras informações suplementares';

  @override
  String get visibility_label => 'Visibilidade do personagem';

  @override
  String get visibility_public => 'Público';

  @override
  String get visibility_private => 'Privado';

  @override
  String get section_voice_gen => '🎙️ Geração de voz exclusiva dele';

  @override
  String get voice_gen_desc =>
      'Insira comandos para dar a ele uma voz única no mundo!\n(💡 Dica: Se não gostar após gerar, você pode refazer a qualquer momento!)';

  @override
  String get voice_generating_status => 'Preparando a voz...';

  @override
  String get voice_select_prompt =>
      '✨ Preparei três tipos de voz, escolha uma:';

  @override
  String voice_sample_name(int index) {
    return 'Amostra de voz $index';
  }

  @override
  String get voice_sample_desc =>
      'Clique no cartão para escolher, clique à direita para ouvir';

  @override
  String get voice_preparing => 'A voz ainda está sendo preparada...';

  @override
  String get voice_retry => 'Descartar e tentar novamente';

  @override
  String get voice_confirm_selection => 'Eu escolho você!';

  @override
  String get voice_bind_success_banner =>
      'Voz exclusiva vinculada com sucesso!';

  @override
  String get voice_remake => 'Refazer voz';

  @override
  String get voice_btn_generating => 'Gerando, aguarde...';

  @override
  String get voice_btn_generate => 'Inserir comandos para gerar voz exclusiva';

  @override
  String get voice_advanced_tuning => '🎛️ Avançado: Ajustar emoção da fala';

  @override
  String get voice_stability_low => 'Selvagem/Sopro 🐺';

  @override
  String voice_stability_value(String value) {
    return 'Racionalidade: $value';
  }

  @override
  String get voice_stability_high => 'Estável/Calmo 🤖';

  @override
  String get voice_style_low => 'Distante/Reprimido 🧊';

  @override
  String voice_style_value(String value) {
    return 'Expressão dramática: $value';
  }

  @override
  String get voice_style_high => 'Exagerado/Apaixonado 🔥';

  @override
  String get voice_test_btn_testing => 'Aplicando emoção...';

  @override
  String get voice_test_btn => 'Ouvir emoção atual';

  @override
  String get section_social_circle => '👥 Círculo social dele';

  @override
  String get social_circle_desc =>
      'Configure a opinião dele sobre outros personagens. Quando o jogador mencionar alguém no chat, ele reagirá com base nisso (Ex: ciúmes, raiva).';

  @override
  String get social_no_drama =>
      'Ainda não há conflitos com outros personagens...';

  @override
  String social_target(String name) {
    return 'Alvo: $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'Opinião: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return 'Editar opinião sobre $name 💬';
  }

  @override
  String get social_attitude_label => 'A opinião / Atitude dele';

  @override
  String get social_attitude_hint =>
      'Ex: Acha o outro irritante, mas no fundo depende dele...';

  @override
  String get social_save_changes => 'Salvar alterações';

  @override
  String get social_add_title => 'Adicionar relação 🤝';

  @override
  String get social_select_target => 'Selecionar alvo';

  @override
  String get social_thoughts_label => 'A opinião dele sobre esta pessoa...';

  @override
  String get social_thoughts_hint =>
      'Ex: Aquele pianista é muito barulhento...';

  @override
  String get social_add_confirm => 'Confirmar adição';

  @override
  String get gallery_load_failed =>
      'Falha ao carregar imagem 🥲\nVerifique a rede; se for Web, verifique o console.';

  @override
  String gallery_affection_req(int level) {
    return 'Afeição $level';
  }

  @override
  String get gallery_upload_limit => 'Máximo de 10 imagens permitido';

  @override
  String get gallery_photo_setup => 'Definir condições de desbloqueio';

  @override
  String get gallery_photo_desc_label => 'O que é esta foto?';

  @override
  String get gallery_photo_desc_hint => 'Ex: Foto de pijama, foto de encontro';

  @override
  String get gallery_photo_req_label =>
      'Quanta afeição necessária para desbloquear?';

  @override
  String get gallery_photo_req_hint => 'Insira um número, 0 significa grátis';

  @override
  String get gallery_cancel_upload => 'Cancelar upload';

  @override
  String get gallery_confirm_add => 'Confirmar adição';

  @override
  String get default_photo_desc => 'Foto exclusiva';

  @override
  String get draft_photo_desc => 'Foto rascunho';

  @override
  String get loading_text => 'Carregando...';

  @override
  String get default_unnamed_character => 'Personagem sem nome';

  @override
  String elevenlabs_error(String code) {
    return 'Erro ElevenLabs: $code';
  }

  @override
  String get voice_sample_script =>
      '(Limpa a garganta) Olá. Este é um teste de voz exclusivo para mim. Nos próximos dias, estarei aqui com você. Seja nos momentos felizes ou tristes, você pode compartilhar comigo. Você se sente confortável com este ritmo e tom de voz? Se gostar, vamos definir esta voz como minha voz exclusiva para conversar com você. Ansioso por cada um dos nossos dias futuros.';

  @override
  String get voice_test_script =>
      'O que você acha do meu tom de voz agora? Se estiver satisfeito, vamos definir assim.';

  @override
  String get field_background => 'Histórico do Personagem';

  @override
  String get field_tone => 'Tom e Hábitos';

  @override
  String get field_initial_story => 'História Inicial';

  @override
  String get update_action => 'Atualizar';

  @override
  String get default_new_player => 'Novo Jogador';

  @override
  String get translating_status => 'Traduzindo...';

  @override
  String get translate_profile_btn => 'Traduzir Conteúdo do Perfil';

  @override
  String translate_failed(String error) {
    return 'Falha na tradução: $error';
  }

  @override
  String get like_own_char_warning =>
      'Você não pode curtir um personagem criado por você mesmo! 🤭';

  @override
  String get like_success_msg =>
      'Curtida enviada! O criador ficará muito feliz💖';

  @override
  String get unlike_success_msg => 'Curtida removida 💔';

  @override
  String get like_label => 'Curtir';

  @override
  String get dislike_label => 'Não curtir';

  @override
  String get block_char => 'Bloquear este personagem';

  @override
  String get char_blocked_msg => 'Personagem bloqueado.';

  @override
  String get dislike_dialog_title => 'Não gostou deste personagem?';

  @override
  String get dislike_dialog_subtitle =>
      'Diga-nos o motivo em segredo, faremos uma análise:';

  @override
  String get dislike_hint => 'Configurações chatas, imagens inadequadas...';

  @override
  String get dislike_thanks =>
      'Obrigado pelo feedback! Recebemos sua mensagem secreta.';

  @override
  String get dislike_submit => 'Enviar em segredo';

  @override
  String get report_title => '📢 Denunciar Comentário';

  @override
  String get report_subtitle =>
      'Selecione o motivo da denúncia:\nAnalisaremos o conteúdo o mais rápido possível.';

  @override
  String get report_opt_1 => 'Conteúdo pornográfico ou violência gráfica';

  @override
  String get report_opt_2 => 'Difamação, insulto ou ataque ao personagem';

  @override
  String get report_opt_3 => 'Discurso de ódio ou ataque pessoal';

  @override
  String get report_opt_4 => 'Spam ou fraude publicitária';

  @override
  String get report_opt_5 => 'Outro conteúdo impróprio';

  @override
  String get report_confirm => 'Confirmar Denúncia';

  @override
  String get report_success =>
      'Denúncia enviada, notificação recebida! O conteúdo será analisado em breve 🛡️';

  @override
  String get report_failed =>
      'Falha na denúncia, verifique sua conexão de rede.';

  @override
  String get lore_delete_title => '⚠️ Aviso: Apagar Memória';

  @override
  String get lore_delete_content =>
      'Esta memória desaparecerá para sempre uma vez apagada, tem certeza de que deseja excluí-la?';

  @override
  String get lore_delete_cancel => 'Erro de clique';

  @override
  String get lore_delete_confirm => 'Confirmar exclusão';

  @override
  String get lore_delete_success =>
      '🗑️ Fragmento de memória apagado completamente.';

  @override
  String get lore_add_title => 'Escrever Nova Memória 🖋️';

  @override
  String get lore_edit_title => 'Editar Fragmento de Memória 🖋️';

  @override
  String get lore_title_label => 'Título da Memória';

  @override
  String get lore_title_hint => 'Ex: O dia chuvoso do primeiro encontro';

  @override
  String get lore_teaser_label => 'Resumo / Introdução';

  @override
  String get lore_teaser_hint => 'Breve descrição exibida no cartão...';

  @override
  String get lore_content_label => 'Conteúdo Completo da Memória';

  @override
  String get lore_content_hint =>
      'Escreva a história detalhada ou as configurações aqui...';

  @override
  String get lore_lock_label => '🔒 Selar esta Memória';

  @override
  String get lore_lock_desc =>
      'Ao marcar, apenas o criador poderá ver, os jogadores não terão acesso';

  @override
  String get lore_empty_error =>
      'O título e o conteúdo não podem estar vazios!';

  @override
  String get lore_add_success => '✨ Nova memória selada com sucesso!';

  @override
  String get lore_publish => 'Publicar Memória';

  @override
  String get lore_save_edit => 'Salvar Alterações';

  @override
  String lore_write_first(Object pronoun) {
    return 'Venha escrever o primeiro passado para $pronoun!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return 'Aguardando a história com $pronoun...';
  }

  @override
  String get lore_sealed_msg =>
      '🔒 Esta memória foi selada e não pode ser visualizada no momento.';

  @override
  String get lore_not_open_msg =>
      'Esta memória ainda não está aberta ao público...';

  @override
  String get lore_unnamed => 'Fragmento Sem Nome';

  @override
  String get lore_add_btn_limit =>
      'Escrever novo fragmento de memória (máximo 10)';

  @override
  String get lore_collapse => 'Fechar Carta';

  @override
  String get echo_delete_title => '🗑️ Excluir Comentário';

  @override
  String get echo_delete_content =>
      'Tem certeza de que deseja excluir este Eco do Espaço-Tempo?\nUma vez excluído, não poderá ser recuperado!';

  @override
  String get echo_keep => 'Manter';

  @override
  String get echo_clear_success => 'Eco do espaço-tempo limpo 🧹';

  @override
  String get echo_energy_full_title => '⚠️ Energia Cósmica no Limite';

  @override
  String get echo_energy_full_content =>
      'Sua energia do espaço-tempo atingiu o limite (máximo 3), exclua suas experiências antigas para abrir novos registros cósmicos!';

  @override
  String get echo_write_title => 'Deixe seu Eco do Espaço-Tempo 🌌';

  @override
  String get echo_write_subtitle =>
      'Escreva sua experiência ou frases inspiradoras aqui!';

  @override
  String get echo_hint =>
      '「Mesmo que seja o fim do mundo, priorizarei sua respiração...」';

  @override
  String get echo_theme_label => 'Escolha a borda da nota:';

  @override
  String get theme_butterfly => 'Borboleta';

  @override
  String get theme_sprout => 'Broto';

  @override
  String get theme_star => 'Céu Estrelado';

  @override
  String get theme_planet => 'Planeta';

  @override
  String get echo_publish_btn => 'Publicar Registro do Espaço-Tempo';

  @override
  String get echo_wall_title => 'Mural de Ecos do Espaço-Tempo';

  @override
  String get echo_leave_memory => 'Deixar Experiência';

  @override
  String get echo_empty_msg =>
      'Nenhum viajante do espaço-tempo deixou um registro ainda...\nVocê quer ser o primeiro?';

  @override
  String get creator_label => 'Criador';

  @override
  String get follow_btn => 'Seguir';

  @override
  String get followed_btn => 'Seguindo';

  @override
  String get follow_own_warning => 'Criadores não podem seguir a si mesmos! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName seguiu $creatorName!';
  }

  @override
  String get mailbox_follow_title => 'Novo Guardião Obtido 🦋';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName acabou de seguir você!';
  }

  @override
  String get tab_private_profile => 'Perfil Privado';

  @override
  String get tab_memory_fragments => 'Fragmentos de Memória';

  @override
  String get tab_time_echoes => 'Ecos do Espaço-Tempo';

  @override
  String get chat_free_btn => 'Chat (Grátis)';

  @override
  String get start_story_btn => 'Iniciar História';

  @override
  String get default_chat_initial => 'Precisa de algo?';

  @override
  String get gallery_title => 'Fundo de Chamada Exclusivo';

  @override
  String gallery_current_affection(String value) {
    return 'Nível de afeição atual: $value 💕';
  }

  @override
  String get gallery_empty => 'Ainda não há fotos no álbum';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'Fundo definido como \"$desc\"!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'Alcance o nível de afeição $value para desbloquear! 🍃';
  }

  @override
  String get gallery_reset_bg => 'Fundo de chamada padrão restaurado';

  @override
  String get background_story_title => 'História de Fundo';

  @override
  String get background_story_empty =>
      'Este personagem é misterioso, ainda não há uma história de fundo...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'Seguindo $creatorName 🦋';
  }

  @override
  String get mailbox_title => 'Caixa de Entrada Exclusiva 💌';

  @override
  String get mailbox_empty =>
      'A caixa de entrada está vazia. Vá publicar algo para atraí-lo!';

  @override
  String get new_notification => 'Nova Notificação';

  @override
  String get default_he => 'Ele';

  @override
  String affection_upgrade_title(String charName) {
    return 'O afeto de $charName por você aumentou! 💖';
  }

  @override
  String get flower_reward => '🌸 Recebeu 5 pontos de flores';

  @override
  String get affection_quote_lv5 =>
      '「Não esperava... que você se tornasse tão importante para mim. Tão importante que... não consigo imaginar um mundo sem você.」';

  @override
  String get affection_quote_lv4 =>
      '「A coisa mais sortuda da minha vida foi, provavelmente, naquele dia, olhar para trás e ver você.」';

  @override
  String get affection_quote_lv3 =>
      '「Ultimamente... percebi que ando distraído com mais frequência, e minha cabeça está completamente cheia de você.」';

  @override
  String get affection_quote_lv2 =>
      '「Já que é o seu convite, suponho que eu possa liberar um pouco de tempo, não é impossível.」';

  @override
  String get affection_quote_lv1 =>
      '「Tenho visto você com frequência ultimamente, e sinto... que não odeio essa frequência de encontros.」';

  @override
  String get affection_quote_lv0 =>
      '「Então você também está aqui. Isso seria algum tipo de destino curioso?」';

  @override
  String get lore_edit_success =>
      '✨ Fragmento de memória atualizado com sucesso!';

  @override
  String get delete_failed_network =>
      'Falha ao excluir, verifique a rede ou as permissões.';

  @override
  String get ai_chat_language => 'Português';

  @override
  String get ai_chat_language_code => 'pt-PT';

  @override
  String get chat_home_title => 'Mensagens';

  @override
  String get call_memory_tooltip => 'Memórias de Chamadas';

  @override
  String get login_to_view_chat => 'Faça login para ver o histórico';

  @override
  String load_chat_failed(String error) {
    return 'Falha ao carregar lista: $error';
  }

  @override
  String get chat_list_empty => 'A sala de chat está vazia...';

  @override
  String get go_to_encounter => 'Vá em \"Encontro\" para falar com alguém!';

  @override
  String confirm_delete_chat(String charName) {
    return 'Tem certeza de que deseja excluir a conversa com $charName?';
  }

  @override
  String affection_score_short(String score) {
    return 'Afeição $score';
  }

  @override
  String get character_not_found =>
      'Dados não encontrados; o personagem pode ter sido excluído.';

  @override
  String get preparing_chat_room => 'Preparando sua sala de chat exclusiva...';

  @override
  String get rename_chat_title => 'Nomeie esta memória';

  @override
  String get rename_chat_hint =>
      'Ex: Mudar (Cheng Yu) para (Contagem Regressiva para o Divórcio)';

  @override
  String get save_tag_btn => 'Salvar Etiqueta';

  @override
  String get room_name_updated => 'Nome da sala atualizado!';

  @override
  String update_failed(String error) {
    return 'Falha na atualização: $error';
  }

  @override
  String get chat_mode_daily => 'Diário';

  @override
  String get chat_mode_story => 'História';

  @override
  String get chat_mode_immersive => 'Imersivo';

  @override
  String get chat_mode_gemini => 'Chat';

  @override
  String get lang_zh => '繁體中文';

  @override
  String get lang_ja => '日本語';

  @override
  String get lang_ko => '한국어';

  @override
  String get lang_en => 'English';

  @override
  String get lang_vi => 'Tiếng Việt';

  @override
  String get chat_load_char_failed =>
      'Dados do personagem não encontrados. Volte e tente novamente ou verifique a rede.';

  @override
  String get chat_jump_success => 'Saltou para esta parte da memória 🍃';

  @override
  String get chat_create_room_failed =>
      'A conexão parece instável. Falha ao criar sala, tente novamente.';

  @override
  String get chat_secret_file_title => '🔒 Arquivo Confidencial';

  @override
  String get chat_secret_file_desc =>
      'O arquivo de alma deste personagem foi arquivado ou definido como privado. Os detalhes estão temporariamente indisponíveis.';

  @override
  String get chat_understood => 'Entendi';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ Nova memória obtida: $title';
  }

  @override
  String get chat_egg_saved =>
      'Adicionado automaticamente à sua mochila exclusiva';

  @override
  String get chat_points_not_enough_title => 'Flores Insuficientes';

  @override
  String get chat_points_not_enough_desc =>
      'Suas flores não são suficientes! Vá à loja para recarregar.';

  @override
  String chat_call_confirm_title(String name) {
    return 'Ligar para $name?';
  }

  @override
  String get chat_call_rule_1 => 'Cada chamada custará 20 flores';

  @override
  String get chat_call_rule_2 =>
      'A chamada dura um minuto. Se não puder falar, pode usar texto';

  @override
  String get chat_call_rule_3 =>
      'Recomendamos o uso de fones de ouvido para ouvir a voz dele com clareza ✨';

  @override
  String get chat_call_btn_cancel => 'Agora não';

  @override
  String get chat_call_pref_title => 'Defina suas preferências de chamada';

  @override
  String get chat_call_lang_select => 'Escolher idioma da chamada';

  @override
  String get chat_call_save_memory => 'Salvar memória desta chamada';

  @override
  String get chat_call_save_memory_desc =>
      'Pode ser ouvida novamente após o fim da chamada';

  @override
  String get chat_call_btn_start => 'Iniciar chamada';

  @override
  String chat_points_shortage(String points) {
    return 'Pontos de flores insuficientes! Você tem $points pontos';
  }

  @override
  String get chat_room_not_ready =>
      'A sala de chat não está pronta, entre novamente.';

  @override
  String get chat_stop_generating_msg =>
      'Resposta interrompida, pontos não foram deduzidos 🍃';

  @override
  String get chat_heartbeat_up => 'O coração dele acelerou...';

  @override
  String get chat_heartbeat_down => 'O olhar dele esfriou...';

  @override
  String get chat_msg_copy => 'Copiar conteúdo';

  @override
  String get chat_msg_copied => 'Copiado para a área de transferência!';

  @override
  String get chat_msg_report => 'Denunciar esta conversa';

  @override
  String get chat_msg_suggest => 'Dar sugestão';

  @override
  String get chat_report_title => 'Denunciar esta conversa';

  @override
  String get chat_report_lang => 'Idioma estrangeiro detectado';

  @override
  String get chat_report_inapp => 'Resposta inadequada';

  @override
  String get chat_report_context => 'Contexto sem conexão';

  @override
  String get chat_report_other => 'Outros motivos';

  @override
  String get chat_report_hint => 'Descreva o problema encontrado...';

  @override
  String get chat_report_submit => 'Enviar';

  @override
  String get chat_report_success =>
      '✅ Denúncia enviada, faremos os ajustes em breve';

  @override
  String get chat_suggest_title => 'Dar sugestões';

  @override
  String get chat_suggest_hint => 'Escreva sua valiosa opinião...';

  @override
  String get chat_suggest_success =>
      '💖 Obrigado pela sugestão, trataremos disso em breve';

  @override
  String get chat_del_warn =>
      'As mensagens não podem ser recuperadas após serem excluídas.';

  @override
  String get chat_reset_title => 'Redefinir memória';

  @override
  String get chat_reset_desc =>
      'Escolha o nível de redefinição:\n\n1. 【Apenas Chat】: Limpa o histórico, mas mantém o afeto.\n2. 【Redefinição Total】: Tudo volta ao zero, como no primeiro encontro.';

  @override
  String get chat_reset_only_chat => 'Apenas histórico de chat';

  @override
  String get chat_reset_full => 'Redefinição total';

  @override
  String get chat_reset_full_msg =>
      'Tudo voltou ao início, ele não se lembra mais de você...';

  @override
  String get chat_reset_chat_msg =>
      'Chat esvaziado, mas o amor dele por você permanece.';

  @override
  String get chat_edit_ai_hint => 'Editar a resposta dele...';

  @override
  String get chat_edit_user_hint => 'Insira o novo conteúdo...';

  @override
  String chat_no_voice_msg(String name) {
    return 'Ainda não há voz para $name...';
  }

  @override
  String get chat_poke_btn => 'Cutucar';

  @override
  String get chat_poke_success =>
      '✨ Cutucamos o criador por você! Fique atenta para quando a voz dele estiver online~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'Pontos de flores insuficientes! Precisa de $cost pontos 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ Alma Gêmea ✨';

  @override
  String get chat_levelup_normal => 'Relação subiu de nível! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'Gravar na alma';

  @override
  String get chat_levelup_btn_normal => 'Aceitar com emoção';

  @override
  String get chat_loc_title => '📍 Enviar localização virtual';

  @override
  String get chat_loc_custom_btn => 'Enviar localização personalizada';

  @override
  String get chat_loc_hint => 'Inserir outro lugar... (Ex: No seu coração)';

  @override
  String get chat_loc_1 => 'Embaixo da sua casa';

  @override
  String get chat_loc_2 => 'Na escola';

  @override
  String get chat_loc_3 => 'No café que acabamos de passar';

  @override
  String get chat_loc_4 => 'Na conveniência';

  @override
  String get chat_interact_title => '✨ O que quer fazer com ele?';

  @override
  String get chat_interact_action => 'Cutucadas e pequenos gestos';

  @override
  String get chat_interact_gift => 'Enviar um presente (consome flores 🌸)';

  @override
  String get chat_action_poke => 'Cutucar bochecha';

  @override
  String get chat_action_hug => 'Pedir um abraço';

  @override
  String get chat_action_hand => 'Segurar a mão escondido';

  @override
  String get chat_dice_btn => 'Lançar dados';

  @override
  String get chat_loading_failed =>
      'Falha ao carregar memória, volte e tente novamente.';

  @override
  String get chat_test_mode_msg =>
      'Modo de teste ativado, converse à vontade! (As conversas não serão salvas)';

  @override
  String get chat_empty_msg => 'Comece uma jornada emocionante com ele!';

  @override
  String get chat_ai_typing => 'Ele está respondendo...';

  @override
  String get chat_input_hint_default => 'O que quer dizer para ele...';

  @override
  String get chat_typing_indicator => 'Digitando...';

  @override
  String get chat_menu_search => 'Pesquisar conversa';

  @override
  String get chat_menu_gallery => 'Memórias e fundos exclusivos';

  @override
  String get chat_menu_aboutme => 'Sobre mim';

  @override
  String get chat_menu_memo => 'Memorando para ele';

  @override
  String get chat_menu_period => 'Seguimento menstrual';

  @override
  String get chat_menu_reset => 'Redefinir memória';

  @override
  String get chat_search_hint => 'Qual conversa doce você quer reviver?';

  @override
  String get chat_search_empty => 'Memória não encontrada 🥺';

  @override
  String get chat_search_you => 'Você disse';

  @override
  String get chat_search_him => 'Ele disse';

  @override
  String get chat_tool_backpack => 'Mochila';

  @override
  String get chat_tool_story => 'Resumo da história';

  @override
  String get chat_tool_photo => 'Fotos';

  @override
  String get chat_tool_record => 'Gravação';

  @override
  String get chat_tool_profile => 'Arquivo ShiGuang';

  @override
  String get chat_tool_interact => 'Interações';

  @override
  String get chat_record_recording => 'Gravando...';

  @override
  String get chat_record_start => 'Clique no microfone para gravar';

  @override
  String get chat_record_done => 'Gravação concluída';

  @override
  String get chat_mode_daily_desc =>
      'Chat diário leve e divertido, como amigos!';

  @override
  String get chat_mode_story_desc =>
      'Progressão da história como em um romance.';

  @override
  String get chat_mode_immersive_desc =>
      'Experiência sensorial máxima, interação profunda sem limites.';

  @override
  String get chat_switch_mode_title => 'Alternar modo de chat';

  @override
  String get chat_voice_call => 'Chamada de voz';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【Evento do Sistema】$playerName enviou um 【$giftName】.';
  }

  @override
  String get rel_title_soulmate => 'Alma Gêmea/Amor Profundo';

  @override
  String get rel_title_lover => 'Fase de Paixão/Namorado Exclusivo';

  @override
  String get rel_title_ambiguous => 'Fase Ambígua/Testando Terreno';

  @override
  String get rel_title_friend => 'Amigo Comum/Afeição Surgindo';

  @override
  String get rel_title_acquaintance => 'Conhecido/Ligeiramente Familiar';

  @override
  String get rel_title_stranger => 'Estranho/Recém-conhecidos';

  @override
  String get rel_title_tense => 'Relação Tensa/Sentindo Irritação';

  @override
  String get rel_title_avoiding => 'Como Estranhos/Evitando Deliberadamente';

  @override
  String get rel_title_hostile => 'Extrema Repulsa/Hostilidade Fria';

  @override
  String get rel_title_nemesis => 'Inimigo Mortal/Nunca se Ver Novamente';

  @override
  String get rel_msg_soulmate =>
      '「Não esperava... que você se tornasse tão importante para mim. Tão importante que... não consigo imaginar um mundo sem você.」';

  @override
  String get rel_msg_lover =>
      '「A coisa mais sortuda da minha vida foi, provavelmente, naquele dia, olhar para trás e ver você.」';

  @override
  String get rel_msg_ambiguous =>
      '「Ultimamente... percebi que ando distraído com mais frequência, e minha cabeça está completamente cheia de você.」';

  @override
  String get rel_msg_friend =>
      '「Já que é o seu convite, suponho que eu possa liberar um pouco de tempo, não é impossível.」';

  @override
  String get rel_msg_acquaintance =>
      '「Tenho visto você com frequência ultimamente, e sinto... que não odeio essa frequência de encontros.」';

  @override
  String get rel_msg_stranger =>
      '「Então você também está aqui. Isso seria algum tipo de destino curioso?」';

  @override
  String chat_edit_char_count(String count) {
    return '$count caracteres';
  }

  @override
  String get chat_mysterious_player => 'Jogador Misterioso';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'O jogador $playerName está ansioso para ouvir a voz de $characterName, vá gerá-la agora!';
  }

  @override
  String get gift_heart => 'Coração';

  @override
  String get gift_flower => 'Flor';

  @override
  String get gift_sun => 'Sol';

  @override
  String get gift_confetti => 'Confete';

  @override
  String get gift_coffee => 'Café';

  @override
  String get gift_cake => 'Bolo';

  @override
  String get chat_action_poke_prompt =>
      '(O jogador estende a mão de repente e cutuca sua bochecha de brincadeira)';

  @override
  String get chat_action_hug_prompt =>
      '(O jogador abre os braços carente, pedindo um abraço caloroso)';

  @override
  String get chat_action_hand_prompt =>
      '(O jogador segura sua mão discretamente debaixo da mesa)';

  @override
  String get chat_menu_send_location => 'Enviar Localização Virtual';

  @override
  String get weekday_mon => '(Seg)';

  @override
  String get weekday_tue => '(Ter)';

  @override
  String get weekday_wed => '(Qua)';

  @override
  String get weekday_thu => '(Qui)';

  @override
  String get weekday_fri => '(Sex)';

  @override
  String get weekday_sat => '(Sáb)';

  @override
  String get weekday_sun => '(Dom)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ Nova memória obtida: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'Adicionado automaticamente à sua mochila exclusiva';

  @override
  String get chat_profile_updated_msg =>
      'Arquivo ShiGuang atualizado! Ele se lembrará das suas configurações mais recentes 🍃';

  @override
  String get comment_loading_author => 'Carregando...';

  @override
  String comment_post_failed(String error) {
    return 'Falha ao comentar, verifique a rede: $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      'Tem certeza de que deseja excluir permanentemente este comentário?';

  @override
  String get comment_delete_failed => 'Falha ao excluir, verifique sua conexão';

  @override
  String get comment_identity_title => 'Escolher Identidade';

  @override
  String get comment_identity_myself => 'Eu mesmo';

  @override
  String get comment_report_title => 'Confirmar Denúncia';

  @override
  String get comment_report_rules_title =>
      '⚖️ Regras de Denúncia de Comentários';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ 1ª infração: Aviso do sistema e um registro de violação.\n2️⃣ 2ª infração: Proibição de comentar por 1 dia.\n3️⃣ Reincidência: Função de denúncia desativada por 14 dias e visibilidade reduzida.\n\n🚨 Para casos de malícia grave:\nProibição de interagir com personagens por 1 dia e ID postado no mural por 3 dias (proibido alterar o ID durante este tempo).\n\n💡 Após o envio da denúncia, o resultado final será enviado via [Correio do Jogo].\nPor favor, respeite os outros e denuncie com sensatez.';

  @override
  String get comment_report_understood => 'Eu entendi';

  @override
  String get comment_report_confirm_desc =>
      'Tem certeza de que deseja denunciar este comentário?\nDenúncias mal-intencionadas podem resultar em punição.';

  @override
  String get comment_report_submit_btn => 'Confirmar Denúncia';

  @override
  String get comment_report_success =>
      'Obrigado pela denúncia, verificaremos o mais breve possível!';

  @override
  String get comment_report_failed =>
      'Falha ao enviar denúncia, tente novamente mais tarde.';

  @override
  String get comment_option_delete => 'Excluir Comentário';

  @override
  String get comment_option_report => 'Denunciar Comentário';

  @override
  String comment_time_days_ago(String days) {
    return 'há $days dias';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return 'há $hours horas';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return 'há $mins minutos';
  }

  @override
  String get comment_time_just_now => 'Agora mesmo';

  @override
  String get comment_sheet_title => 'Comentários';

  @override
  String get comment_empty_state =>
      'Ainda não há comentários, seja o primeiro!';

  @override
  String get comment_reply_btn => 'Responder';

  @override
  String comment_replying_to(String name) {
    return 'Respondendo a @$name';
  }

  @override
  String comment_input_hint(String name) {
    return 'Comentar como $name...';
  }

  @override
  String char_story_expect(String pronoun) {
    return 'Ansioso(a) pela história com $pronoun...';
  }

  @override
  String get common_update_failed => 'Falha ao atualizar, verifique a rede';

  @override
  String get char_edit_fragment => 'Editar fragmento';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 Não gosta: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 Gosta: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age anos | $job';
  }

  @override
  String get common_got_it => 'Entendi';

  @override
  String get common_add_failed => 'Falha ao adicionar, verifique a rede';

  @override
  String common_delete_failed_with_err(String error) {
    return 'Falha ao excluir, verifique o estado da rede: $error';
  }

  @override
  String get char_exclusive_guardian => 'Guardião Exclusivo 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName curtiu $charName!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '[Trad] $content (Este é o conteúdo emocional traduzido)';
  }

  @override
  String get player_default_nickname => 'Viajante';

  @override
  String get moment_create_title => 'Criar Nova Publicação';

  @override
  String get moment_create_post_btn => 'Publicar';

  @override
  String get moment_create_hint => 'Compartilhe algo novo...';

  @override
  String get moment_create_error_empty =>
      'Pelo menos texto ou uma imagem é necessário!';

  @override
  String get moment_create_error_failed =>
      'Falha ao publicar, tente novamente mais tarde';

  @override
  String get moment_create_visibility_public => 'Público (Visível para todos)';

  @override
  String get moment_create_visibility_private =>
      'Privado (Visível apenas para amigos)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (O jogador enviou uma localização: $location)';
  }

  @override
  String get chat_you => 'Você';

  @override
  String get chat_opponent => 'Oponente';

  @override
  String chat_dice_duel_result(String name) {
    return '[Evento do Sistema] Duelo de dados com $name! O resultado saiu...';
  }

  @override
  String get chat_loading_status => 'Carregando...';

  @override
  String chat_error_load_msg(String error) {
    return 'Falha ao carregar a mensagem: $error';
  }

  @override
  String get chat_voice_msg_label => 'Mensagem de voz';

  @override
  String chat_special_story_trigger(String title) {
    return '[História Especial Desbloqueada: $title]';
  }

  @override
  String common_edit_failed(String error) {
    return 'Falha ao editar: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'Falha ao redefinir: $error';
  }

  @override
  String get chat_default_greeting => 'Olá...';

  @override
  String get chat_memory_cleared => 'Memória completamente apagada';

  @override
  String get chat_history_reset => 'Conversa redefinida';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 [ Arquivo ShiGuang Exclusivo - $name ]\n━━━━━━━━━━━━━━━━━━\n🔹 Nome: $identity\n🔹 Aniversário: $birthday\n🔹 Altura: $height\n🔹 Aparência: $appearance\n🔹 Profissão: $job\n\n📖 [ Sobre os Fragmentos da Alma Dela ]\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 [ Arquivo ShiGuang Exclusivo ]\n━━━━━━━━━━━━━━━━━━\n🔹 Apelido: $nickname\n🔹 Aniversário: $birthday\n\n🔒 Outros dados do personagem ainda não estão desbloqueados...\n(Preencha o perfil completo para deixá-lo conhecer você melhor no universo paralelo! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'Arquivo sem nome';

  @override
  String get chat_default_player_name => 'Jogador';

  @override
  String get error_system_confusion =>
      'O sistema está um pouco confuso, tente novamente.';

  @override
  String get error_msg_send_failed =>
      'Falha ao enviar mensagem, tente novamente.';

  @override
  String get error_system_busy =>
      'Sistema ocupado, tente novamente mais tarde.';

  @override
  String get error_network_unavailable =>
      'No momento, não é possível conectar, tente novamente.';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 Chamada encerrada, você falou com $name por $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'História Exclusiva: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'Esta é uma memória oculta exclusiva para você e $name...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return 'Uma memória exclusiva sobre \"$keyword\" foi desbloqueada silenciosamente...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '[Evento Oculto Acionado: $title]\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(Ele olha para você em silêncio, como se esperasse você falar primeiro)';

  @override
  String get chat_new_room_created => 'Nova sala de chat criada';

  @override
  String portfolio_title(String nickname) {
    return 'Portfólio de $nickname';
  }

  @override
  String get enter_secret_studio => 'Entrar no meu estúdio secreto';

  @override
  String get no_public_character_mine =>
      'Você ainda não publicou nenhum personagem público!\nVá para o estúdio e crie um ✨';

  @override
  String get no_public_character_other =>
      'Este criador ainda não publicou nenhum personagem...';

  @override
  String get delete_draft_title => 'Excluir Rascunho';

  @override
  String get confirm_delete_draft_msg =>
      'Tem certeza de que deseja excluir este personagem inacabado?\n(Não pode ser desfeito após a exclusão)';

  @override
  String get draft_cleared_success => 'Rascunho limpo com sucesso 🧹';

  @override
  String get login_required_for_studio =>
      'Faça login primeiro para entrar no estúdio!';

  @override
  String get my_secret_studio_title => 'Meu Estúdio Secreto 🛠️';

  @override
  String get create_new_character_btn => 'Criar Novo Personagem';

  @override
  String get unnamed_draft => 'Rascunho sem nome';

  @override
  String get click_to_edit_story =>
      'Clique para continuar editando a história dele...';

  @override
  String get label_draft => 'Rascunho';

  @override
  String get studio_empty_title => 'O estúdio está vazio no momento';

  @override
  String get studio_empty_subtitle =>
      'Clique no canto inferior para começar a criar seu primeiro personagem!';

  @override
  String get common_no_changes => 'Nenhuma alteração';

  @override
  String get moment_updated_success => 'Publicação atualizada!';

  @override
  String common_save_failed(String error) {
    return 'Falha ao salvar: $error';
  }

  @override
  String get moment_edit_title => 'Editar publicação';

  @override
  String get action_change_image => 'Alterar imagem';

  @override
  String get action_remove_image => 'Remover imagem';

  @override
  String get moment_delete_confirm_title =>
      'Tem certeza de que deseja excluir esta publicação?';

  @override
  String get moment_delete_confirm_content =>
      'Depois de excluída, esta memória dos Momentos desaparecerá!';

  @override
  String get action_confirm_delete => 'Confirmar Exclusão';

  @override
  String get friend_unknown => 'Um amigo';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname curtiu sua publicação! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname acha que $authorName é charmoso(a) e deixou uma curtida! ✨';
  }

  @override
  String get moment_like_success => 'Seu batimento cardíaco foi entregue! ✨';

  @override
  String get moment_notification_new_like => 'Nova Curtida! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname mencionou @$name em uma publicação! ✨';
  }

  @override
  String get moment_detail_title => 'Detalhes da Publicação';

  @override
  String get moment_not_found =>
      'Esta publicação parece ter desaparecido... 😢';

  @override
  String get moment_comment_title => 'Comentários dos Momentos';

  @override
  String get moment_comment_empty =>
      'Ainda não há comentários, seja a primeira a responder! 🛋';

  @override
  String moment_replying_to(String name) {
    return 'Respondendo a @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return 'Responder a @$name...';
  }

  @override
  String get moment_leave_comment_hint => 'Deixe sua resposta...';

  @override
  String get moment_delete_permanent_confirm =>
      'Esta publicação será excluída permanentemente. Você tem certeza?';

  @override
  String get moment_action_delete => 'Excluir Publicação';

  @override
  String get moment_action_report => 'Denunciar esta publicação';

  @override
  String get moment_action_share => 'Compartilhar esta publicação';

  @override
  String get moment_forward_hint =>
      'Encaminhar esta publicação para um personagem...';

  @override
  String moment_reply_private(String name) {
    return 'Responder por mensagem privada para $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'Vamos conversar com $name sobre esta publicação! 💬';
  }

  @override
  String get moment_share_to_apps => 'Compartilhar em outros aplicativos';

  @override
  String moment_likes_label(String count) {
    return '$count Folhas';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】Venha ver a publicação de $author: $content\n\nBaixe agora e comece seus momentos exclusivos: $appLink';
  }

  @override
  String get moment_forward_title =>
      'Encaminhar para o personagem com quem está conversando 💌';

  @override
  String get moment_forward_empty_state =>
      'Você ainda não tem conversas ativas!\nVá ao Saguão para encontrar alguém especial 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【Encaminhou uma publicação】\nAutor: $author\nConteúdo: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ Compartilhado discretamente com $name!';
  }

  @override
  String get action_send => 'Enviar';

  @override
  String get memo_delete_confirm =>
      'Tem certeza de que deseja excluir esta nota? Esta ação não pode ser desfeita.';

  @override
  String get memo_add_title => 'Adicionar Nota';

  @override
  String get memo_edit_title => 'Editar Nota';

  @override
  String memo_hint_text(String name) {
    return 'O que você gostaria de anotar sobre $name?';
  }

  @override
  String get memo_label_reminder_date => 'Data do Lembrete:';

  @override
  String get memo_action_save => 'Salvar Nota';

  @override
  String get memo_error_empty_content => 'O conteúdo não pode estar vazio!';

  @override
  String memo_list_title(String name) {
    return 'Notas com $name';
  }

  @override
  String get memo_empty_state =>
      'Ainda não há notas!\nClique no canto superior direito para adicionar uma!';

  @override
  String memo_reminder_date_display(String date) {
    return 'Data do Lembrete: $date';
  }

  @override
  String get daily_gift_title => 'Presente Diário do Tempo';

  @override
  String daily_login_welcome(String appName, String amount) {
    return 'Bem-vindo(a) de volta ao $appName!\nFaça o check-in hoje para resgatar $amount pontos de Linguagem das Flores. 🌸';
  }

  @override
  String get title_daily_check_in => 'Check-in Diário';

  @override
  String success_claim_reward(String amount) {
    return 'Resgatou $amount pontos de Linguagem das Flores com sucesso! 🌸';
  }

  @override
  String get error_claim_failed =>
      'Falha no resgate, verifique sua conexão e tente novamente.';

  @override
  String get action_claim_now => 'Resgatar Agora';

  @override
  String get common_or => 'ou';

  @override
  String get title_language_settings => 'Configurações de Idioma';

  @override
  String get app_name => 'Lianlian Shiguang';

  @override
  String get login_slogan => 'Comece seus momentos exclusivos';

  @override
  String get login_with_google => 'Entrar com o Google';

  @override
  String get login_with_apple => 'Entrar com a Apple';

  @override
  String get login_with_facebook => 'Entrar com o Facebook';

  @override
  String get login_with_email => 'Entrar com a conta Lianlian (E-mail)';

  @override
  String get title_contact_us_heading =>
      'Nós valorizamos muito suas sugestões!';

  @override
  String get desc_contact_us_body =>
      'Por favor, escreva suas ideias aqui para nos ajudar a melhorar o jogo.';

  @override
  String get error_feedback_empty =>
      'O conteúdo da sugestão não pode estar vazio!';

  @override
  String get email_subject_feedback =>
      'Lianlian Shiguang - Feedback dos Jogadores';

  @override
  String get msg_email_app_not_found_copied =>
      'Não foi possível abrir o aplicativo de e-mail automaticamente. O e-mail oficial foi copiado para você!';

  @override
  String get title_contact_us => 'Fale Conosco';

  @override
  String get desc_contact_us =>
      'Nós valorizamos muito suas sugestões!\nPor favor, escreva suas ideias aqui para nos ajudar a melhorar o jogo.';

  @override
  String get hint_enter_feedback => 'Por favor, insira sua sugestão aqui...';

  @override
  String get action_send_via_email => 'Enviar por E-mail';

  @override
  String get error_email_password_empty =>
      'O e-mail e a senha não podem ficar em branco!';

  @override
  String get auth_error_default =>
      'Ocorreu um erro, tente novamente mais tarde.';

  @override
  String get auth_error_user_not_found =>
      'Este e-mail não foi encontrado, por favor registre-se primeiro!';

  @override
  String get auth_error_wrong_password => 'Senha incorreta, tente novamente!';

  @override
  String get auth_error_email_in_use =>
      'Este e-mail já está registrado! Por favor, faça login diretamente.';

  @override
  String get auth_error_weak_password =>
      'A senha é muito fraca, digite pelo menos 6 caracteres!';

  @override
  String get auth_error_invalid_email => 'Formato de e-mail inválido!';

  @override
  String get title_welcome_back => 'Bem-vindo(a) de volta';

  @override
  String get title_register_account => 'Registrar conta exclusiva';

  @override
  String get label_email => 'E-mail';

  @override
  String get label_password => 'Senha';

  @override
  String get action_login => 'Entrar';

  @override
  String get action_register => 'Registrar';

  @override
  String get prompt_no_account =>
      'Ainda não tem uma conta? Clique aqui para se registrar';

  @override
  String get prompt_has_account => 'Já tem uma conta? Clique aqui para entrar';

  @override
  String get error_nickname_empty => 'O apelido não pode ficar em branco!';

  @override
  String get profile_saved_success => 'Perfil salvo!';

  @override
  String get error_id_empty => 'O ID não pode ficar em branco!';

  @override
  String get error_id_too_long =>
      'O comprimento do ID não pode exceder 10 caracteres!';

  @override
  String get error_id_already_used =>
      'Este ID já está em uso, por favor escolha outro!';

  @override
  String profile_save_failed(String error) {
    return 'Falha ao salvar: $error';
  }

  @override
  String get draft_saved_success_msg =>
      'Entendido! Salvo nos rascunhos para você, volte e edite a qualquer momento! ✨';

  @override
  String get dialog_reminder_title => 'Lembrete';

  @override
  String get warning_id_not_edited =>
      'O ID exclusivo ainda não foi editado. Tem certeza de que deseja salvar agora?';

  @override
  String get action_continue_editing => 'Continuar editando';

  @override
  String get action_edit_later => 'Editar mais tarde';

  @override
  String get action_edit_later_short => 'Editar depois';

  @override
  String get action_cancel_changes => 'Cancelar alterações';

  @override
  String get error_birthdate_locked =>
      'A data de nascimento foi definida e não pode ser alterada!';

  @override
  String get action_select_avatar => 'Selecionar avatar';

  @override
  String get action_choose_from_gallery => 'Escolher da galeria';

  @override
  String get title_adjust_avatar => 'Ajustar seu avatar';

  @override
  String get avatar_updated_success => 'Avatar atualizado para você 🍃';

  @override
  String get title_create_profile => 'Crie seu perfil';

  @override
  String get title_edit_profile => 'Editar perfil';

  @override
  String get label_your_nickname => 'Seu apelido';

  @override
  String get label_player_exclusive_id => 'ID exclusivo de jogador';

  @override
  String get msg_id_locked =>
      'O ID está bloqueado e não pode ser alterado novamente.';

  @override
  String get msg_id_change_chance =>
      'Você tem uma chance gratuita de alterar seu ID.';

  @override
  String get action_select_birthdate =>
      'Por favor, selecione a data de nascimento';

  @override
  String label_birthdate(String date) {
    return 'Data de nascimento: $date';
  }

  @override
  String get msg_birthdate_immutable =>
      'O aniversário não pode ser alterado depois de definido ✨';

  @override
  String get action_start_journey => 'Iniciar a jornada';

  @override
  String get action_add_image => 'Adicionar imagem';

  @override
  String moment_like_self(String nickname) {
    return '$nickname curtiu sua publicação! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname acha que $authorName é charmoso(a) e deixou uma curtida! ✨';
  }

  @override
  String get task_social_tour_complete =>
      '✨ Missão de Tour Social concluída! Lembre-se de resgatar suas flores! 🌸';

  @override
  String get wall_title_shiguang => 'Mural ShiGuang';

  @override
  String get wall_tab_explore => '🌍 Explorar';

  @override
  String get wall_tab_exclusive => '🔒 Exclusivo';

  @override
  String get more_options => 'Mais Opções';

  @override
  String get delete_warning =>
      'Após a exclusão, a postagem não poderá ser recuperada';

  @override
  String get delete_success => 'Excluído com sucesso';

  @override
  String get notification_new_comment => 'Novo comentário! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName curtiu sua publicação!';
  }

  @override
  String get empty_public_moments_prompt =>
      'Atualmente está vazio,\nvá publicar sua primeira postagem pública! 🌍';

  @override
  String get empty_private_moments_prompt =>
      'Ainda não há momentos no círculo de amigos,\nvá criar memórias com ele! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'Este arquivo de alma foi arquivado pelo criador, definido como privado ou desapareceu no fluxo do tempo...\n\nTalvez em um universo paralelo, vocês tenham a chance de se encontrar novamente. ✨';

  @override
  String get leave_silently => 'Sair silenciosamente';

  @override
  String get character_post_schedule =>
      'Agendamento de Postagens de Personagens';

  @override
  String get creator_self => 'Criador(a) próprio(a)';

  @override
  String get post_identity_prompt => 'Com qual identidade você postará hoje?';

  @override
  String get identity_creator => '✨ Identidade de Criador';

  @override
  String get identity_character => 'Identidade de Personagem';

  @override
  String get decide_post_time_prompt =>
      'Ajude-os a decidir o horário da postagem!';

  @override
  String get auto_post_schedule_hint =>
      'Quando ativado, as postagens diárias serão publicadas automaticamente no horário especificado\n(💡 Dica: Defina horários quebrados para parecer mais humano!)';

  @override
  String get no_characters_created_yet =>
      'Você ainda não criou nenhum personagem!';

  @override
  String time_hour(String hour) {
    return '$hour horas';
  }

  @override
  String time_minute(String minute) {
    return '$minute minutos';
  }

  @override
  String get empty_public_moments_short => 'Ainda não há postagens públicas 🌍';

  @override
  String get empty_private_moments_short =>
      'O círculo de amigos ainda está silencioso ✨';

  @override
  String get my_created_characters => 'Meus Personagens Criados';

  @override
  String get no_characters_yet => 'Nenhum personagem criado ainda';

  @override
  String play_count_display(int count) {
    return 'Número de jogadas: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return 'Calendário de Cuidados de $characterName';
  }

  @override
  String get care_calendar_greeting => 'Como você está se sentindo hoje?';

  @override
  String get care_calendar_save_btn =>
      'Salve o registro, deixe ele cuidar de você';

  @override
  String get care_calendar_delete_confirm => 'Deseja excluir este registro?';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"Eu anotei tudo. Estes dias foram difíceis para você, mas eu sempre estarei ao seu lado.\"';
  }

  @override
  String get daily_gift_success => 'Presente diário resgatado com sucesso! 🌸';

  @override
  String get check_in_fail_network =>
      'Falha no check-in, verifique sua conexão de rede 🍃';

  @override
  String task_completed(String taskName) {
    return 'Tarefa concluída: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return 'Resgatou $rewardAmount Flores de \"$taskName\" com sucesso!';
  }

  @override
  String claim_failed_error(String e) {
    return 'Falha no resgate: $e';
  }

  @override
  String get tab_heartbeat_diary => 'Diário de Batimentos';

  @override
  String get tab_daily_chit_chat => 'Bate-papo Diário';

  @override
  String get task_desc_chat_3_times =>
      'Tenha 3 conversas diárias com um personagem';

  @override
  String get tab_story_progression => 'Progressão da História';

  @override
  String get task_desc_story_1_time => 'Conclua 1 interação no modo história';

  @override
  String get tab_social_tour => 'Tour Social';

  @override
  String get task_desc_like_3_moments => 'Curta 3 postagens nos Momentos';

  @override
  String get btn_claimed => 'Resgatado';

  @override
  String get btn_claim => 'Resgatar';

  @override
  String get btn_incomplete => 'Incompleto';

  @override
  String get network_unstable_retry =>
      'Conexão de rede instável, tente novamente mais tarde 🍃';

  @override
  String get title_time_travel => 'Viagem no Tempo';

  @override
  String get select_chat_mode => 'Selecionar Modo de Chat';

  @override
  String get mode_chat => 'Chat';

  @override
  String get mode_daily_desc => 'Bate-papo casual para manter o vínculo';

  @override
  String get mode_story_desc =>
      'Mergulhe na história para uma experiência imersiva';

  @override
  String get greeting_hello => 'Olá!';

  @override
  String get greeting_default_daily => 'Está me procurando?';

  @override
  String get title_personal_homepage => 'Página Pessoal';

  @override
  String get title_time_letters => 'Cartas do Tempo';

  @override
  String get status_signed_in_today => 'Check-in feito hoje';

  @override
  String get status_signing_in => 'Fazendo check-in...';

  @override
  String get status_daily_sign_in => 'Check-in Diário (+10 Flores)';

  @override
  String get toast_id_copied => 'ID copiado!';

  @override
  String get hint_click_avatar_to_edit =>
      'Clique no avatar para editar o perfil';

  @override
  String get title_my_friends => 'Meus Amigos';

  @override
  String get action_show_all => 'Mostrar Tudo';

  @override
  String get empty_no_characters_created =>
      'Você ainda não criou nenhum personagem.';

  @override
  String get common_close => 'Fechar';

  @override
  String get search_companion_title => 'Buscar Companheiro ShiGuang';

  @override
  String get search_name_placeholder => 'Digite o nome dele...';

  @override
  String get search_no_match_hint =>
      'Personagem não encontrado, tentar outro nome? ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age anos | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age anos';
  }

  @override
  String get empty_state_warmth =>
      'O calor residual do tempo e do espaço ainda permanece aqui...';

  @override
  String get error_login_required_add_friend =>
      'Por favor, faça login primeiro para adicionar amigos!';

  @override
  String get dialog_title_remove_friend => 'Confirmar Remoção de Amigo';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return 'Tem certeza de que deseja remover $characterName da sua lista de amigos?';
  }

  @override
  String get action_remove => 'Remover';

  @override
  String snackbar_friend_removed(String characterName) {
    return '$characterName removido(a) dos amigos';
  }

  @override
  String get action_remove_friend => 'Remover Amigo';

  @override
  String get dialog_title_block => 'Confirmar Bloqueio';

  @override
  String dialog_msg_block(String characterName) {
    return 'Após bloquear, você não verá mais nenhuma informação sobre $characterName. Tem certeza de que deseja bloquear?';
  }

  @override
  String snackbar_blocked(String characterName) {
    return '$characterName foi bloqueado(a)';
  }

  @override
  String get action_block_character => 'Bloquear este personagem';

  @override
  String dialog_title_report(String characterName) {
    return 'Denunciar $characterName';
  }

  @override
  String get input_hint_report_reason =>
      'Por favor, insira o motivo da denúncia...';

  @override
  String get action_submit => 'Enviar';

  @override
  String get snackbar_report_success =>
      'Obrigado pela sua denúncia, vamos analisá-la o mais rápido possível.';

  @override
  String get snackbar_report_fail =>
      'Falha ao enviar, tente novamente mais tarde';

  @override
  String get action_report_character => 'Denunciar este personagem';

  @override
  String get title_meet_him => 'Encontre seu crush';

  @override
  String text_character_count(int count) {
    return 'Quantidade de personagens: $count';
  }

  @override
  String get msg_no_more_encounters_today => 'Por hoje é só de encontros!';

  @override
  String get msg_check_new_encounters =>
      'Volte para ver se há novos encontros!';

  @override
  String get action_refresh => 'Atualizar';

  @override
  String get tab_friends => 'Amigos';

  @override
  String get msg_mysterious_profile =>
      'Esta pessoa é muito misteriosa, não deixou nada...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age anos | $identities';
  }

  @override
  String get snackbar_operation_failed =>
      'A operação falhou, tente novamente mais tarde';

  @override
  String get action_view_translation => 'Ver Tradução';

  @override
  String get label_translation_result => 'Resultado da Tradução:';

  @override
  String get errorWebPageUnavailable =>
      'Incapaz de abrir a página da web temporariamente, tente novamente mais tarde';

  @override
  String get resetAppearanceTitle => 'Redefinir aparência?';

  @override
  String get resetAppearanceWarning =>
      'Isso removerá a imagem de fundo e as cores que você escolheu cuidadosamente!';

  @override
  String get appearanceRestored => 'Aparência padrão restaurada';

  @override
  String get confirmReset => 'Confirmar Redefinição';

  @override
  String get resetToDefaultAppearance => 'Restaurar aparência padrão';

  @override
  String get clearCustomSettings =>
      'Limpar todas as cores e imagens de fundo personalizadas';

  @override
  String get contactUs => 'Fale Conosco';

  @override
  String get contactDescription =>
      'Sinta-se à vontade para compartilhar seus pensamentos ou relatar bugs';

  @override
  String get vibrationHapticTitle => 'Vibração de Batimentos';

  @override
  String get vibrationHapticDescription =>
      'Aciona a vibração do telefone quando o nível de afeto muda significativamente';

  @override
  String get splash_loading_universe =>
      'Despertando o universo de \'Lianlian ShiGuang\'...';

  @override
  String get shop_title => 'Loja de Flores';

  @override
  String get shop_current_points_label => 'Pontos de Flores atuais';

  @override
  String get shop_tab_top_up => 'Recarregar Pontos';

  @override
  String get shop_tab_history => 'Histórico de Transações';

  @override
  String get shop_empty_history => 'Ainda não há registros de flores! 🌸';

  @override
  String get shop_unknown_item => 'Item desconhecido';

  @override
  String get shop_first_purchase_bonus => 'Dobro na primeira compra!';

  @override
  String get story_summary_title => 'Nossa História';

  @override
  String get story_summary_empty_content => 'O conteúdo do resumo está vazio.';

  @override
  String get story_summary_deleted_toast => 'Esta memória foi removida';

  @override
  String story_summary_empty_list(String name) {
    return 'A história de vocês ainda não começou...\nConversem mais e deixem que $name \nescreva a primeira memória de vocês! ✨';
  }
}
