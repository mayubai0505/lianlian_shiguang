// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get changeTheme => 'Ganti Warna Tema';

  @override
  String get feedback => 'Umpan Balik dan Saran';

  @override
  String get changeLanguage => 'Ganti Bahasa';

  @override
  String get allFriendsTitle => 'Semua Teman';

  @override
  String get noFriendsMessage => 'Anda belum memiliki teman apa pun.';

  @override
  String get unknownCharacter => 'Karakter tidak dikenal';

  @override
  String errorLoadingFriends(String error) {
    return 'Terjadi kesalahan saat memuat daftar teman: $error';
  }

  @override
  String get tagGentle => 'Lembut';

  @override
  String get tagCheerful => 'Ceria';

  @override
  String get tagLively => 'Hidup';

  @override
  String get tagMischievous => 'Nakal';

  @override
  String get tagRichYoungLady => 'Nona Muda';

  @override
  String get tagRichYoungMaster => 'Tuan Muda';

  @override
  String get tagWealthyFamily => 'Keluarga Kaya';

  @override
  String get tagScheming => 'Licik';

  @override
  String get tagPossessive => 'Posesif';

  @override
  String get tagParanoid => 'Paranoid';

  @override
  String get tagPersistent => 'Gigih';

  @override
  String get tagUncle => 'Paman';

  @override
  String get tagAuntie => 'Bibi';

  @override
  String get tagSeniorSister => 'Kakak Kelas (Perempuan)';

  @override
  String get tagJuniorBrother => 'Adik Kelas (Laki-laki)';

  @override
  String get tagHandsome => 'Tampan';

  @override
  String get tagStunning => 'Sangat Cantik';

  @override
  String get tagContrast => 'Kontras';

  @override
  String get tagFlirty => 'Menggoda';

  @override
  String get tagAgeGap => 'Perbedaan Usia';

  @override
  String get userNotFoundError => 'Pengguna tidak ditemukan';

  @override
  String get imageDataMismatchError =>
      'Data gambar tidak konsisten, silakan pilih gambar lagi.';

  @override
  String get createCharacterTitle => 'Buat Karakter';

  @override
  String get charAlbumTitle =>
      'Album Karakter (Gambar pertama adalah avatar utama)';

  @override
  String get charNameLabel => 'Nama Karakter:';

  @override
  String get charDescSection => 'Deskripsi Karakter:';

  @override
  String get charAgeLabel => 'Usia:';

  @override
  String get charJobLabel => 'Pekerjaan:';

  @override
  String get charBirthdayLabel => 'Tanggal Lahir:(MMDD)';

  @override
  String get charGenderLabel => 'Jenis Kelamin ';

  @override
  String get genderNotSelected => 'Belum Dipilih';

  @override
  String get genderMale => 'Laki-laki';

  @override
  String get genderFemale => 'Perempuan';

  @override
  String get genderOther => 'Lainnya';

  @override
  String get charHeightLabel => 'Tinggi:(cm)';

  @override
  String get charAppearanceLabel => 'Deskripsi Penampilan:';

  @override
  String get charPersonalityTagsSection => 'Tag Kepribadian';

  @override
  String get charOtherPersonalityTagsHint => 'Tag kepribadian lainnya...';

  @override
  String get otherSectionTitle => 'Lainnya';

  @override
  String get charLikesLabel =>
      'Hal yang disukai:(contoh: kue stroberi, kucing, hari hujan)';

  @override
  String get charDislikesLabel =>
      'Hal yang tidak disukai:(contoh: pare, tempat yang bising)';

  @override
  String get charSecretsLabel =>
      'Rahasia kecil yang tidak diketahui: (contoh: sebenarnya buta arah)';

  @override
  String get charMannerismsSection => 'Tingkah laku';

  @override
  String get charToneLabel =>
      'Nada dan gaya bicara: (contoh: dingin kepada orang asing)';

  @override
  String get charDialogueExampleLabel =>
      'Contoh dialog: (Pemain: Kamu baik sekali! Karakter: ...Oh.)';

  @override
  String get charBackgroundSection => 'Latar Belakang Karakter:';

  @override
  String get charBackgroundHint =>
      'Masukkan cerita latar belakang karakter (maksimal 2500 kata)';

  @override
  String get charStoryStartSection => 'Awal Cerita:';

  @override
  String get charStoryStartHint =>
      'Masukkan plot cerita karakter (maksimal 2500 kata)';

  @override
  String get charStorySummaryLabel =>
      'Ringkasan Cerita (maksimal 50 kata, akan ditampilkan di kartu pertemuan)';

  @override
  String get charExtraInfoSection => 'Informasi Tambahan Karakter:';

  @override
  String get charExtraInfoHint => 'Masukkan konten tambahan...';

  @override
  String get charPublicToggleLabel =>
      'Apakah akan dipublikasikan agar pemain lain bisa memainkannya?';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get createButton => 'Buat';

  @override
  String get saveButton => 'Simpan';

  @override
  String get cancelButton => 'Batal';

  @override
  String get exitCreationTitle =>
      'Anda akan keluar dari layar pembuatan karakter';

  @override
  String get saveDraftPrompt => 'Perlu disimpan sebagai draf?';

  @override
  String get draftNeeded => 'Ya';

  @override
  String get draftNotNeeded => 'Tidak';

  @override
  String get editExtraInfoTitle => 'Edit Konten Tambahan';

  @override
  String get nameAndAvatarError =>
      'Silakan isi nama karakter dan unggah setidaknya satu avatar!';

  @override
  String get savingStatus => 'Sedang menyimpan...';

  @override
  String get uploadingImagesStatus => 'Sedang mengunggah gambar...';

  @override
  String get maxImagesError => 'Hanya dapat mengunggah maksimal 10 gambar.';

  @override
  String get uploadingImagesStatusShort => 'Sedang memproses gambar...';

  @override
  String get savingCharacterData => 'Sedang menyimpan data karakter...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'Karakter \"$charName\" berhasil dibuat!';
  }

  @override
  String get uploadImageTimeoutError =>
      'Gagal membuat karakter: Waktu unggah gambar habis, mohon periksa koneksi internet Anda.';

  @override
  String createCharacterGenericError(String error) {
    return 'Gagal membuat karakter: $error';
  }

  @override
  String get settingsSectionAppearance => 'Penampilan dan Konten';

  @override
  String get settingsSectionAccount => 'Manajemen Akun dan Konten';

  @override
  String get settingsSectionAbout => 'Tentang Kami';

  @override
  String get accountManagement => 'Manajemen Akun';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'Tidak Diketahui';

  @override
  String get userIdCopied => 'ID Pengguna telah disalin ke papan klip';

  @override
  String get characterManagement => 'Manajemen Karakter';

  @override
  String get viewBlockedCharacters => 'Lihat Karakter yang Diblokir';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get termsOfService => 'Ketentuan Layanan';

  @override
  String get logoutButton => 'Keluar';

  @override
  String get logoutDialogTitle => 'Anda yakin ingin keluar?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'Saya salah tekan';

  @override
  String get logoutDialogActionConfirm => 'Konfirmasi';

  @override
  String get logoutSuccessSnackbar =>
      'Baik! Saya akan menunggu Anda kembali♥(´∀` )';

  @override
  String get deleteAccountButton => 'Hapus Akun';

  @override
  String get deleteAccountDialogTitle =>
      'Anda yakin ingin menghapus akun ini?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'Tindakan ini tidak dapat dibatalkan, semua data akan dihapus secara permanen!';

  @override
  String get deleteAccountDialogActionCancel =>
      'Tidak, saya tidak ingin menghapus';

  @override
  String get deleteAccountDialogActionConfirm => 'Konfirmasi';

  @override
  String get deleteAccountSuccessSnackbar => 'Akun berhasil dihapus.';

  @override
  String get appDisclaimer =>
      'Karakter dan adegan dalam game ini sepenuhnya fiktif, mohon tidak membawanya ke dalam dunia nyata!';

  @override
  String appVersion(String version) {
    return 'Versi Aplikasi: $version';
  }

  @override
  String get dialogTitleHint => 'Petunjuk';

  @override
  String get completeProfilePrompt =>
      'Silakan edit profil Anda untuk melengkapi informasi Anda terlebih dahulu!';

  @override
  String get goToEdit => 'Pergi ke Edit';

  @override
  String get later => 'Nanti';

  @override
  String chattingWith(String friendName) {
    return 'Mengobrol dengan $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'Isi obrolan dengan $friendName';
  }

  @override
  String get chatInputHint => 'Masukkan pesan...';

  @override
  String get characterNotFoundError => 'Data karakter tidak ditemukan';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'Gagal memuat detail karakter: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'Hubungan awal';

  @override
  String get relationship_childhood_friend => 'Teman masa kecil';

  @override
  String get relationship_senior_junior => 'Kakak/adik kelas';

  @override
  String get relationship_bickering_couple => 'Pasangan yang suka bertengkar';

  @override
  String get relationship_colleagues => 'Rekan kerja';

  @override
  String get relationship_other => 'Lainnya (silakan masukkan secara manual)';

  @override
  String get chatModeDaily => 'Mode Harian';

  @override
  String get chatModeStory => 'Mode Cerita';

  @override
  String get chatModeImmersive => 'Mode Imersif';

  @override
  String get chatModeGemini => 'Pendamping Hidup';

  @override
  String get announcement_new => 'Pengumuman Baru';

  @override
  String get mail_notification =>
      'Surat Waktu baru telah tiba! Segera periksa Gulungan Perkamen!';

  @override
  String get customer_service_reply => 'Balasan Layanan Pelanggan';

  @override
  String get system_announcement => 'Pengumuman Sistem';

  @override
  String get empty_announcement => 'Saat ini tidak ada pengumuman.';

  @override
  String get untitled => 'Tanpa Judul';

  @override
  String get no_content => 'Tidak Ada Konten';

  @override
  String get privacy_policy_title => 'Kebijakan Privasi Lianlian Shiguang';

  @override
  String get privacy_policy_date => 'Pembaruan Terakhir: 10 April 2026';

  @override
  String get privacy_policy_body =>
      'Kebijakan Privasi \"Lianlian Shiguang\"\nTerakhir Diperbarui: 10 April 2026\n\nSelamat datang di \"Lianlian Shiguang\" (selanjutnya disebut \"Layanan\"). Kami sangat menghargai privasi Anda. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda.\n\n1. Informasi Akun:\nLogin Pihak Ketiga: Saat login melalui Google, Facebook, atau Apple, kami mengumpulkan Firebase UID, email, dan nama panggilan publik Anda.\nRegistrasi Email: Jika menggunakan email, kami mengumpulkan alamat email Anda. Kata sandi dikelola dan disimpan melalui enkripsi Firebase; tim pengembang tidak dapat melihat kata sandi asli Anda.\n\nData Interaksi: Agar karakter AI memiliki memori berkelanjutan, kami menyimpan riwayat percakapan Anda dengan AI dan konten yang Anda tulis untuk karakter dalam game.\n\nInformasi Perangkat: Termasuk model perangkat, versi sistem operasi, dan pengenal unik perangkat untuk optimasi sistem.\n\n2. Penggunaan Informasi:\nOptimalisasi AI: Menggunakan riwayat percakapan untuk meningkatkan kualitas respons dan konsistensi kepribadian AI.\nOperasi Layanan: Digunakan untuk memproses pengisian poin, catatan konsumsi, dan verifikasi identitas.\nKeamanan: Memantau perilaku berbahaya untuk melindungi server.\n\n3. Kerja Sama Teknis Pihak Ketiga:\nLayanan ini didukung oleh: Google Cloud / Firebase (Penyimpanan & Autentikasi), OpenRouter / xAI / Meta (Logika AI).\nCatatan: Kami tidak menjual riwayat percakapan asli Anda kepada pengiklan.\n\n4. Penyimpanan & Penghapusan Data:\nData disimpan dengan aman di server cloud. Anda dapat menghubungi kami kapan saja untuk meminta penghapusan permanen akun dan semua data terkait.';

  @override
  String get terms_title => 'Syarat Penggunaan';

  @override
  String get terms_date => 'Pembaruan Terakhir: 10 April 2026';

  @override
  String get terms_body =>
      'Ketentuan Layanan \"Lianlian Shiguang\"\nTerakhir Diperbarui: 10 April 2026\n\nHarap baca ketentuan berikut dengan saksama sebelum menggunakan Layanan. Dengan menggunakan Layanan, Anda setuju dengan hal berikut:\n\n1. Sifat Layanan & Penyangkalan:\nInteraksi Non-Manusia: Semua respons karakter dihasilkan oleh AI (Generative AI). Pernyataan karakter tidak mewakili posisi pengembang.\nRisiko Narasi: AI dapat menghasilkan konten fiktif atau tidak akurat. Pengguna harus mampu membedakan fiksi dan realitas.\n\n2. Poin Virtual & Pembayaran:\nSifat Poin: Poin adalah barang virtual. Setelah dikonsumsi (seperti masuk ke cerita, mode imersif, hadiah, panggilan suara), poin tidak dapat dikembalikan.\nBiaya: Standar konsumsi poin ditetapkan berdasarkan biaya komputasi AI.\n\n3. Kode Etik Pengguna:\nDilarang menggunakan AI untuk menghasilkan konten kekerasan ekstrem, panduan kriminal, atau melanggar hukum.\n\n4. Hak Kekayaan Intelektual:\nKonten Orisinal: Nama karakter (seperti Cheng An), latar belakang, dan naskah adalah milik \"Tim Pengembang Lianlian Shiguang\".\nKonten Hasil AI: Beberapa gambar dihasilkan oleh alat AI (seperti Niji.journey) dengan lisensi komersial yang sah.\n\n5. Penghentian Layanan:\nPelanggaran ketentuan dapat menyebabkan penangguhan akun tanpa pemberitahuan sebelumnya.';

  @override
  String get login_required => 'Silakan login terlebih dahulu';

  @override
  String get cloud_character_mgmt => 'Manajemen Karakter Cloud';

  @override
  String get connection_error => 'Kesalahan Koneksi';

  @override
  String get no_characters_met => 'Anda belum bertemu karakter apa pun!';

  @override
  String get status_paused => 'Status: Kontak Ditangguhkan';

  @override
  String get status_in_progress => 'Status: Dalam Proses';

  @override
  String get unblock => 'Buka Blokir';

  @override
  String get block => 'Blokir';

  @override
  String get confirm_block_title => 'Konfirmasi Blokir?';

  @override
  String block_warning_msg(String charName) {
    return 'Setelah diblokir, Anda untuk sementara tidak akan menerima pesan dari $charName.';
  }

  @override
  String get think_again => 'Pikirkan Lagi';

  @override
  String get confirm_block_btn => 'Konfirmasi Blokir';

  @override
  String get no_char_info => 'Belum ada informasi detail untuk karakter ini...';

  @override
  String get private_mailbox => 'Kotak Surat Pribadi';

  @override
  String get user_info_not_found => 'Informasi pengguna tidak ditemukan';

  @override
  String get load_failed => 'Gagal memuat, silakan coba lagi';

  @override
  String get empty_mailbox => 'Kotak surat saat ini kosong~';

  @override
  String get system_notification => 'Notifikasi Sistem';

  @override
  String get interaction_records => 'Catatan Interaksi';

  @override
  String get liked_content => 'Konten yang Disukai';

  @override
  String get my_favorites => 'Favorit Saya';

  @override
  String get login_to_view_records => 'Silakan login untuk melihat catatan';

  @override
  String get no_likes_yet => 'Anda belum menyukai postingan apa pun!';

  @override
  String get empty_favorites => 'Folder favorit kosong, yuk jelajahi Lobi!';

  @override
  String get theme_sakura_pink => 'Sakura Pink';

  @override
  String get theme_ocean_blue => 'Biru Laut';

  @override
  String get theme_sunset_orange => 'Oren Senja';

  @override
  String get theme_mint_forest => 'Hutan Mint';

  @override
  String get theme_midnight => 'Mode Malam';

  @override
  String get change_atmosphere => 'Ubah Suasana';

  @override
  String get custom_color => 'Warna Kustom';

  @override
  String get custom_color_desc => 'Racik warna suasana eksklusif Anda';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get confirm_delete_title => 'Konfirmasi Hapus';

  @override
  String get confirm_delete_memory_msg =>
      'Apakah Anda yakin ingin dia melupakan ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get delete_btn => 'Hapus';

  @override
  String get memory_erased_msg => 'Ingatan ini telah dihapus.';

  @override
  String get delete_failed_msg => 'Gagal menghapus';

  @override
  String get edit_memory_title => 'Edit Kenangan';

  @override
  String get modify_memory_hint => 'Ubah ingatan ini...';

  @override
  String get memory_re_recorded_msg => 'Ingatan berhasil direkam ulang';

  @override
  String get update_failed_msg => 'Gagal memperbarui';

  @override
  String get update_favorite_failed_msg => 'Gagal memperbarui status favorit';

  @override
  String char_notebook_title(String charName) {
    return 'Buku Catatan $charName';
  }

  @override
  String get error_loading_memory => 'Terjadi kesalahan saat memuat ingatan';

  @override
  String get empty_notebook_msg =>
      'Buku catatan kosong...\nAyo mengobrol agar dia bisa menuliskan semuanya tentang Anda!';

  @override
  String get date_format_text => 'd MMM yyyy';

  @override
  String get remove_special_focus => 'Hapus Fokus Khusus';

  @override
  String get mark_special_focus => 'Tandai sebagai Fokus Khusus';

  @override
  String get edit_btn => 'Edit';

  @override
  String get load_gallery_failed => 'Gagal memuat galeri';

  @override
  String get traditional_chinese => 'Tionghoa Tradisional';

  @override
  String get all => 'Semua';

  @override
  String get official_recommendation => 'Rekomendasi Resmi';

  @override
  String get my_exclusive => 'Eksklusif Saya';

  @override
  String encounter_count(int count) {
    return '$count Pertemuan';
  }

  @override
  String get official => 'Resmi';

  @override
  String get private => 'Pribadi';

  @override
  String get first_encounter => 'Pertemuan Pertama';

  @override
  String char_exclusive_memory(String charName) {
    return 'Kenangan Eksklusif $charName';
  }

  @override
  String affection_required_to_unlock(int affectionLevel) {
    return 'Kasih sayang harus mencapai $affectionLevel untuk membuka kenangan ini!';
  }

  @override
  String get affection => 'Kasih Sayang';

  @override
  String get unlock => 'Buka Kunci';

  @override
  String get change_chat_bg => 'Ubah Latar Obrolan';

  @override
  String confirm_change_chat_bg(String cgDesc, String charName) {
    return 'Jadikan \"$cgDesc\" sebagai latar obrolan dengan $charName?';
  }

  @override
  String bg_changed_to(String cgDesc) {
    return 'Latar diubah menjadi \"$cgDesc\"';
  }

  @override
  String get confirm_change => 'Konfirmasi';

  @override
  String get empty_treasure_box =>
      'Kotak harta karun kosong...\nAyo mengobrol untuk menemukan kejutan tersembunyi!';

  @override
  String get unknown_story => 'Cerita Tidak Diketahui';

  @override
  String get open_this_memory => 'Buka kenangan ini';

  @override
  String get open_exclusive_story => 'Buka cerita eksklusif';

  @override
  String confirm_use_egg(String eggTitle) {
    return 'Alami \"$eggTitle\" sekarang?\n\n(Item ini habis pakai dan akan otomatis masuk ke cerita)';
  }

  @override
  String get wait_a_bit => 'Tunggu sebentar';

  @override
  String guiding_into_story(String eggTitle) {
    return 'Mengarahkan ke cerita...';
  }

  @override
  String get use_now => 'Gunakan Sekarang';

  @override
  String playback_failed_status(String statusCode) {
    return 'Pemutaran gagal, kode status: $statusCode';
  }

  @override
  String get playback_error => 'Terjadi kesalahan pemutaran';

  @override
  String get unknown_contact => 'Kontak Tidak Dikenal';

  @override
  String call_memory_with(String charName) {
    return 'Kenangan Panggilan dengan $charName';
  }

  @override
  String unlock_affection_requirement(int affection) {
    return 'Terbuka pada tingkat afeksi $affection';
  }

  @override
  String get no_call_record =>
      'Sepertinya tidak ada catatan percakapan untuk panggilan ini...';

  @override
  String get me => 'Saya';

  @override
  String get playing => 'Memutar...';

  @override
  String get listen => 'Dengarkan';

  @override
  String get no_exclusive_voice =>
      'Karakter ini belum memiliki suara eksklusif!';

  @override
  String get voice_download_success =>
      'Data suara berhasil diunduh, bersiap untuk memutar...';

  @override
  String get onboarding_invitation => '— Undangan Waktu —';

  @override
  String get onboarding_welcome => 'Selamat datang di Lian Lian Shi Guang';

  @override
  String get onboarding_quote =>
      '\"Setiap pertemuan adalah reuni setelah perpisahan yang panjang.\"';

  @override
  String get onboarding_gift_title => 'Hadiah Pertemuan Pertama: 50 Bunga';

  @override
  String get onboarding_gift_subtitle =>
      'Bunga-bunga ini akan menemani Anda memulai kisah bersamanya.';

  @override
  String get onboarding_start_button => 'Mulai Perjalanan Waktu Anda';

  @override
  String get onboarding_more_info => 'Pelajari lebih lanjut tentang kisah ini';

  @override
  String get legal_agreement_prefix => 'Dengan melanjutkan, Anda menyetujui';

  @override
  String get legal_terms_button => 'Ketentuan Layanan';

  @override
  String get legal_and => ' dan ';

  @override
  String get legal_privacy_button => 'Kebijakan Privasi';

  @override
  String get call_memory_title => 'Kenangan Panggilan';

  @override
  String get please_login_first => 'Silakan masuk terlebih dahulu';

  @override
  String get no_call_memories =>
      'Belum ada kenangan panggilan yang disimpan.\nMaksimal 10 catatan yang dapat disimpan.';

  @override
  String call_with_name(String name) {
    return 'Panggilan dengan $name';
  }

  @override
  String call_duration(String time) {
    return 'Durasi: $time';
  }

  @override
  String get delete_call_title => 'Hapus Catatan';

  @override
  String delete_call_confirm(String name) {
    return 'Apakah Anda yakin ingin menghapus kenangan ini dengan $name?\n(Tindakan ini tidak dapat dibatalkan)';
  }

  @override
  String get keep_it => 'Simpan saja';

  @override
  String get confirm_delete => 'Hapus';

  @override
  String get press_mic_to_speak => 'Tekan mikrofon untuk mulai berbicara...';

  @override
  String get call_ended => 'Panggilan berakhir';

  @override
  String character_thinking(String name) {
    return '($name sedang berpikir...)';
  }

  @override
  String character_picking_up(String name) {
    return '($name sedang mengangkat telepon...)';
  }

  @override
  String get call_interrupted_login =>
      '(Panggilan terputus) Silakan masuk terlebih dahulu...';

  @override
  String get silence => '(Hening)';

  @override
  String get bad_signal => '(Sinyal buruk...)';

  @override
  String get static_noise => '(Derau statis)... tidak terdengar jelas...';

  @override
  String get type_message_hint => 'Ketik pesan...';

  @override
  String get draft_saved_success =>
      'Draf berhasil disimpan dengan aman di Studio Rahasia!';

  @override
  String get draft_save_failed => 'Gagal menyimpan, silakan coba lagi nanti';

  @override
  String get draft_save_title => 'Simpan draf?';

  @override
  String get draft_save_content =>
      'Karya Anda belum dipublikasikan, ingin menyimpannya di Studio Rahasia terlebih dahulu?';

  @override
  String get not_save => 'Jangan simpan';

  @override
  String get save_draft => 'Simpan draf';

  @override
  String confirm_delete_char_content(String name) {
    return 'Apakah Anda yakin ingin menghapus karakter \"$name\"?\n\nTindakan ini tidak dapat dibatalkan!';
  }

  @override
  String get char_deleted => 'Karakter telah dihapus';

  @override
  String get ok_button => 'Oke!';

  @override
  String get cannot_save_title => 'Tidak dapat menyimpan';

  @override
  String get cannot_save_content =>
      'Harap isi nama karakter dan unggah setidaknya satu avatar!';

  @override
  String get word_count_exceeded => 'Jumlah kata melebihi batas';

  @override
  String word_count_error_detail(String field, int limit) {
    return '\"$field\" telah melebihi $limit kata, harap kurangi sebelum menyimpan.';
  }

  @override
  String get content_missing => 'Konten tidak lengkap';

  @override
  String get content_missing_personality =>
      'Harap isi \"Kepribadian Detail\"! Tulis minimal 10 kata.';

  @override
  String get content_missing_bg =>
      '\"Perkenalan Karakter\" terlalu pendek! Tulis minimal 20 kata untuk menjelaskan latar belakang.';

  @override
  String get content_missing_tone =>
      'Harap atur \"Nada dan Kebiasaan\", agar karakter tidak keluar dari kepribadian (OOC)!';

  @override
  String get user_not_found => 'Kesalahan: Pengguna tidak ditemukan';

  @override
  String char_saved_success(String name, String action) {
    return 'Karakter \"$name\" telah berhasil $action!';
  }

  @override
  String save_error_detail(String error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String get easter_egg_add_title => 'Tambah Easter Egg Tersembunyi';

  @override
  String get easter_egg_edit_title => 'Edit Easter Egg';

  @override
  String get keyword_label => 'Kata Kunci Pemicu (Wajib)';

  @override
  String get keyword_hint => 'Contoh: pergi ke taman hiburan, kue stroberi';

  @override
  String get egg_title_label => 'Judul Easter Egg (Untuk dilihat pemain)';

  @override
  String get egg_title_hint => 'Contoh: Kencan Akhir Pekan';

  @override
  String get egg_teaser_label => 'Cuplikan Singkat (Untuk dilihat pemain)';

  @override
  String get egg_teaser_hint =>
      'Gambarkan awal dari kejadian yang akan datang...';

  @override
  String get egg_scene_label => 'Pergantian Adegan Paksa (Opsional)';

  @override
  String get egg_scene_hint => 'Contoh: Taman Hiburan, Rumah Hantu';

  @override
  String get egg_prompt_label => 'Instruksi Skenario';

  @override
  String get egg_prompt_hint =>
      'Bagaimana menjalankan alur cerita ini.\n(Sistem: Adegan berpindah ke taman hiburan, karakter melihat (Nama Pemain) dan tersenyum...)';

  @override
  String get confirm_button => 'Konfirmasi';

  @override
  String get keyword_empty_error => 'Kata kunci tidak boleh kosong';

  @override
  String get voice_custom_title => 'Kustomisasi Suara Eksklusif';

  @override
  String get voice_custom_hint =>
      'Contoh: CEO dingin dan berwibawa, pemuda lembut...';

  @override
  String get voice_generate_start => 'Mulai menghasilkan';

  @override
  String get voice_bind_first =>
      'Silakan pilih dan \"Hubungkan\" suara eksklusif terlebih dahulu!';

  @override
  String get voice_test_failed =>
      'Gagal mendengar: Silakan klik \"Aku memilihmu!\" untuk menghubungkan suara secara resmi sebelum melakukan penyesuaian!';

  @override
  String voice_name_default(String name) {
    return 'Suara Eksklusif $name';
  }

  @override
  String get voice_description_default =>
      'Ini adalah suara unik yang dibuat untuk karakter eksklusif di \"Lian Lian Shi Guang\", dipilih dan dihasilkan oleh pemain.';

  @override
  String get voice_bind_failed =>
      'Gagal menghubungkan suara, silakan periksa kuota API atau status jaringan';

  @override
  String voice_bind_success(String name) {
    return 'Suara jiwa \"$name\" telah resmi terhubung!';
  }

  @override
  String get voice_bind_success_draft =>
      'Suara berhasil terhubung! Sekarang Anda dapat menggeser slider untuk menguji emosi!';

  @override
  String sync_failed(String error) {
    return 'Sinkronisasi gagal, periksa jaringan: $error';
  }

  @override
  String edit_character_title(String name) {
    return 'Edit $name';
  }

  @override
  String get test_mode_tooltip => 'Tes Fungsi Lengkap';

  @override
  String get test_mode_notice =>
      'Mode tes akan memotong poin sesuai harga asli setiap mode, dan tidak akan dihitung dalam ingatan resmi!';

  @override
  String get delete_character_tooltip => 'Hapus Karakter';

  @override
  String get tab_basic_story => 'Dasar & Cerita';

  @override
  String get tab_voice => 'Suara Eksklusif';

  @override
  String get tab_relationship => 'Hubungan Sosial';

  @override
  String get save_changes_button => 'Simpan Perubahan';

  @override
  String get section_basic_info => 'Informasi Dasar';

  @override
  String get hint_occupation =>
      'Mendukung banyak identitas, gunakan garis miring atau koma (Contoh: Mahasiswa/Hacker)';

  @override
  String get hint_appearance =>
      'Contoh: Rambut perak panjang, mata amber, selalu memakai jas putih...';

  @override
  String get section_story_identity => 'Cerita dan Identitas Anda';

  @override
  String get story_identity_desc =>
      'Tentukan pembukaan cerita dan pengaturan khusus untuk \"Anda\" di simpanan ini';

  @override
  String get advanced_writing_tips_title => 'Tips Menulis Lanjutan:\n';

  @override
  String get advanced_writing_tips_1 => 'Masukkan dalam cerita atau dialog ';

  @override
  String get advanced_writing_tips_2 => '(Nama Pemain)';

  @override
  String get advanced_writing_tips_3 =>
      ', sistem akan secara otomatis menggantinya dengan nama panggilan asli pemain saat bermain!\n';

  @override
  String get advanced_writing_tips_4 => 'Contoh: \"';

  @override
  String get advanced_writing_tips_5 => '(Nama Pemain)';

  @override
  String get advanced_writing_tips_6 => ', kenapa kamu baru datang sekarang?\"';

  @override
  String get background_label => 'Latar Belakang & Pandangan Dunia Karakter';

  @override
  String get background_hint =>
      'Gambarkan masa lalunya dan pandangan dunianya (seperti: kota modern, ABO, akhir dunia). Contoh: Ini adalah dunia yang dipenuhi zombie, dan dia adalah tentara khusus yang melindungimu...';

  @override
  String get story_summary_label => 'Ringkasan Cerita dalam Satu Kalimat';

  @override
  String get story_initial_label => 'Cerita Pertemuan Awal';

  @override
  String get story_initial_hint =>
      'Contoh: Kamu mendorong pintu dan melihatnya duduk di dekat jendela. Dia menoleh dan berkata: \"(Nama Pemain), kemarilah.\"';

  @override
  String get first_line_label => 'Kalimat Pertama Karakter';

  @override
  String get first_line_hint =>
      'Contoh: (Nama Pemain), akhirnya kamu datang juga.';

  @override
  String get section_personality_evo => 'Evolusi Kepribadian & Afeksi';

  @override
  String get detailed_personality_label => 'Kepribadian Detail';

  @override
  String get detailed_personality_hint =>
      'Gambarkan kepribadian intinya. Contoh: Tsundere, keras di luar lembut di dalam. Dingin pada orang lain, hanya tersenyum pada pemain.';

  @override
  String get affection_evo_desc =>
      'AI akan menentukan kapan afeksi meningkat berdasarkan pengaturan berikut:';

  @override
  String get stage_1_label => 'Tahap 1: Asing/Waspada (Lv1)';

  @override
  String get stage_1_hint =>
      'Reaksi saat pertama kali bertemu. Syarat afeksi (Contoh: sopan, tidak mencampuri privasi).';

  @override
  String get stage_2_label => 'Tahap 2: Akrab/Teman (Lv2)';

  @override
  String get stage_2_hint =>
      'Perubahan setelah akrab. Syarat afeksi (Contoh: berbagi manisan, mengobrol tentang kucing).';

  @override
  String get stage_3_label => 'Tahap 3: Intim/Kekasih (Lv3)';

  @override
  String get stage_3_hint =>
      'Reaksi setelah benar-benar jatuh cinta. Apakah dia akan cemburu? Atau merajuk diam-diam?';

  @override
  String get social_interaction_label => 'Interaksi Sosial & Lingkungan';

  @override
  String get social_interaction_hint =>
      'Contoh: Bagaimana dia memperlakukan orang asing? Bagaimana reaksinya saat menghadapi hal yang dia benci?';

  @override
  String get section_habits => 'Kesukaan & Kebiasaan';

  @override
  String get tone_hint_detail =>
      'Wajib diisi. Contoh: Berbicara singkat, suka bertanya balik. Kata andalannya adalah \"bodoh\". Dilarang menggunakan gaya bahasa terjemahan mesin.';

  @override
  String get dialogue_example_hint =>
      'Pemain: Aku lelah sekali.\nKarakter: (Mengelus kepala) Anak pintar, cepat istirahat.';

  @override
  String get section_easter_eggs => 'Easter Egg & Cerita Spesial';

  @override
  String get no_easter_eggs =>
      'Belum ada Easter Egg, klik tombol di bawah untuk menambah';

  @override
  String get no_scene_change => 'Jangan ganti adegan';

  @override
  String get add_easter_egg_button => 'Tambah Easter Egg Tersembunyi';

  @override
  String get other_extra_info => 'Informasi Tambahan Lainnya';

  @override
  String get visibility_label => 'Visibilitas Karakter';

  @override
  String get visibility_public => 'Publik';

  @override
  String get visibility_private => 'Pribadi';

  @override
  String get section_voice_gen => 'Pembuatan Suara Eksklusif';

  @override
  String get voice_gen_desc =>
      'Masukkan kata perintah untuk memberinya suara yang unik di dunia!\n(Tips: Jika tidak puas setelah dihasilkan, Anda dapat membuatnya ulang kapan saja!)';

  @override
  String get voice_generating_status => 'Sedang meramu suara...';

  @override
  String get voice_select_prompt =>
      'Telah disiapkan tiga jenis suara untukmu, silakan pilih:';

  @override
  String voice_sample_name(int index) {
    return 'Sampel Suara $index';
  }

  @override
  String get voice_sample_desc =>
      'Klik kartu untuk memilih, klik kanan untuk mendengar';

  @override
  String get voice_preparing => 'Suara masih dalam persiapan...';

  @override
  String get voice_retry => 'Batalkan dan coba lagi';

  @override
  String get voice_confirm_selection => 'Aku memilihmu!';

  @override
  String get voice_bind_success_banner =>
      'Suara eksklusif berhasil dihubungkan!';

  @override
  String get voice_remake => 'Buat ulang suara';

  @override
  String get voice_btn_generating => 'Sedang menghasilkan, mohon tunggu...';

  @override
  String get voice_btn_generate =>
      'Masukkan kata perintah untuk menghasilkan suara';

  @override
  String get voice_advanced_tuning => 'Lanjutan: Penyesuaian Emosi Bicara';

  @override
  String get voice_stability_low => 'Liar/Napas';

  @override
  String voice_stability_value(String value) {
    return 'Rasionalitas: $value';
  }

  @override
  String get voice_stability_high => 'Stabil/Tenang';

  @override
  String get voice_style_low => 'Dingin/Tertekan';

  @override
  String voice_style_value(String value) {
    return 'Ekspresi Dramatis: $value';
  }

  @override
  String get voice_style_high => 'Lebay/Penuh Perasaan';

  @override
  String get voice_test_btn_testing => 'Menerapkan emosi...';

  @override
  String get voice_test_btn => 'Dengar emosi saat ini';

  @override
  String get section_social_circle => 'Lingkaran Sosialnya';

  @override
  String get social_circle_desc =>
      'Atur pandangannya terhadap karakter lain. Saat pemain menyebut orang tersebut dalam obrolan, dia akan bereaksi berdasarkan pengaturan ini (Contoh: cemburu, marah).';

  @override
  String get social_no_drama =>
      'Saat ini belum ada perselisihan dengan karakter lain...';

  @override
  String social_target(String name) {
    return 'Target: $name';
  }

  @override
  String social_attitude(String attitude) {
    return 'Pandangan: $attitude';
  }

  @override
  String social_edit_title(String name) {
    return 'Edit pandangan terhadap $name';
  }

  @override
  String get social_attitude_label => 'Pandangan / Sikapnya';

  @override
  String get social_attitude_hint =>
      'Contoh: Merasa orang itu berisik, tapi sebenarnya bergantung padanya...';

  @override
  String get social_save_changes => 'Simpan perubahan';

  @override
  String get social_add_title => 'Tambah Hubungan Karakter';

  @override
  String get social_select_target => 'Pilih target';

  @override
  String get social_thoughts_label => 'Pandangannya terhadap orang ini...';

  @override
  String get social_thoughts_hint =>
      'Contoh: Pemain piano itu terlalu berisik...';

  @override
  String get social_add_confirm => 'Konfirmasi tambah';

  @override
  String get gallery_load_failed =>
      'Gagal memuat gambar \nPastikan jaringan normal.';

  @override
  String gallery_affection_req(int level) {
    return 'Afeksi $level';
  }

  @override
  String get gallery_upload_limit =>
      'Maksimal hanya dapat mengunggah 10 gambar';

  @override
  String get gallery_photo_setup => 'Atur Syarat Buka Foto';

  @override
  String get gallery_photo_desc_label => 'Foto apakah ini?';

  @override
  String get gallery_photo_desc_hint => 'Contoh: Foto piyama, foto kencan';

  @override
  String get gallery_photo_req_label => 'Butuh berapa afeksi untuk membuka?';

  @override
  String get gallery_photo_req_hint => 'Masukkan angka, 0 berarti gratis';

  @override
  String get gallery_cancel_upload => 'Batalkan unggahan';

  @override
  String get gallery_confirm_add => 'Konfirmasi tambah';

  @override
  String get default_photo_desc => 'Foto Eksklusif';

  @override
  String get draft_photo_desc => 'Foto Draf';

  @override
  String get loading_text => 'Memuat...';

  @override
  String get default_unnamed_character => 'Karakter Tanpa Nama';

  @override
  String elevenlabs_error(String code) {
    return 'Kesalahan ElevenLabs: $code';
  }

  @override
  String get voice_sample_script =>
      '(Berdehem) Halo. Ini adalah tes suara eksklusif untukku. Di hari-hari mendatang, aku akan ada di sini bersamamu. Baik saat senang maupun sedih, kamu bisa berbagi denganku. Apakah kamu terbiasa dengan irama dan nada bicara seperti ini? Jika menurutmu bagus, mari kita tetapkan suara ini sebagai suara eksklusifku untuk mengobrol denganmu. Menantikan setiap hari masa depan kita.';

  @override
  String get voice_test_script =>
      'Apakah kamu benar-benar tahu apa yang aku pikirkan setiap kali aku melihatmu? ... Sungguh, aku tidak tahu harus bagaimana menghadapimu.';

  @override
  String get field_background => 'Latar Belakang Karakter';

  @override
  String get field_tone => 'Nada dan Kebiasaan';

  @override
  String get field_initial_story => 'Cerita Awal';

  @override
  String get update_action => 'Perbarui';

  @override
  String get default_new_player => 'Pemain Baru';

  @override
  String get translating_status => 'Menerjemahkan...';

  @override
  String get translate_profile_btn => 'Terjemahkan Profil';

  @override
  String translate_failed(String error) {
    return 'Terjemahan gagal: $error';
  }

  @override
  String get like_own_char_warning =>
      'Tidak bisa menyukai karakter buatan sendiri!';

  @override
  String get like_success_msg =>
      'Suka telah dikirim! Kreator akan sangat senang';

  @override
  String get unlike_success_msg => 'Batal menyukai';

  @override
  String get like_label => 'Suka';

  @override
  String get dislike_label => 'Tidak Suka';

  @override
  String get block_char => 'Blokir karakter ini';

  @override
  String get char_blocked_msg => 'Karakter ini telah diblokir.';

  @override
  String get dislike_dialog_title => 'Kurang suka karakter ini?';

  @override
  String get dislike_dialog_subtitle =>
      'Beri tahu kami alasannya secara rahasia, kami akan meninjaunya:';

  @override
  String get dislike_hint => 'Pengaturan membosankan, gambar tidak sesuai...';

  @override
  String get dislike_thanks =>
      'Terima kasih atas masukannya! Kami telah menerima pesan rahasia Anda.';

  @override
  String get dislike_submit => 'Kirim Rahasia';

  @override
  String get report_title => 'Laporkan Komentar';

  @override
  String get report_subtitle =>
      'Pilih alasan pelaporan:\nKami akan meninjau konten segera setelah pelaporan.';

  @override
  String get report_opt_1 => 'Konten pornografi atau kekerasan sadis';

  @override
  String get report_opt_2 => 'Fitnah, penghinaan, atau menyerang karakter';

  @override
  String get report_opt_3 => 'Ujaran kebencian atau serangan pribadi';

  @override
  String get report_opt_4 => 'Pesan spam atau penipuan iklan';

  @override
  String get report_opt_5 => 'Konten tidak pantas lainnya';

  @override
  String get report_confirm => 'Konfirmasi Laporan';

  @override
  String get report_success =>
      'Laporan berhasil, notifikasi telah diterima! Konten akan segera ditinjau ';

  @override
  String get report_failed =>
      'Laporan gagal, silakan periksa koneksi internet.';

  @override
  String get lore_delete_title => 'Peringatan: Hapus Memori';

  @override
  String get lore_delete_content =>
      'Memori ini akan hilang sepenuhnya setelah dihapus, yakin ingin menghapusnya?';

  @override
  String get lore_delete_cancel => 'Salah tekan';

  @override
  String get lore_delete_confirm => 'Konfirmasi Hapus';

  @override
  String get lore_delete_success => 'Fragmen memori telah dihapus sepenuhnya.';

  @override
  String get lore_add_title => 'Tulis Memori Baru ';

  @override
  String get lore_edit_title => 'Edit Fragmen Memori ';

  @override
  String get lore_title_label => 'Judul Memori';

  @override
  String get lore_title_hint => 'Contoh: Hari hujan saat pertama kali bertemu';

  @override
  String get lore_teaser_label => 'Ringkasan / Pengantar';

  @override
  String get lore_teaser_hint => 'Deskripsi singkat yang muncul di kartu...';

  @override
  String get lore_content_label => 'Isi Memori Lengkap';

  @override
  String get lore_content_hint =>
      'Tuliskan cerita detail atau pengaturan di sini...';

  @override
  String get lore_lock_label => ' Segel Memori Ini';

  @override
  String get lore_lock_desc =>
      'Setelah dicentang, hanya kreator yang bisa melihat, pemain tidak bisa melihatnya';

  @override
  String get lore_empty_error => 'Judul dan isi tidak boleh kosong!';

  @override
  String get lore_add_success => 'Memori baru telah berhasil disegel!';

  @override
  String get lore_publish => 'Publikasikan Memori';

  @override
  String get lore_save_edit => 'Simpan Perubahan';

  @override
  String lore_write_first(Object pronoun) {
    return 'Ayo tulis kenangan pertama untuk $pronoun!';
  }

  @override
  String lore_waiting(Object pronoun) {
    return 'Menantikan cerita bersama $pronoun...';
  }

  @override
  String get lore_sealed_msg =>
      'Memori ini telah disegel, saat ini tidak dapat dilihat.';

  @override
  String get lore_not_open_msg => 'Memori ini belum dibuka untuk umum...';

  @override
  String get lore_unnamed => 'Fragmen Tanpa Nama';

  @override
  String get lore_add_btn_limit => 'Tulis fragmen memori baru (Maksimal 10)';

  @override
  String get lore_collapse => 'Tutup Surat';

  @override
  String get echo_delete_title => 'Hapus Komentar';

  @override
  String get echo_delete_content =>
      'Yakin ingin menghapus Gema Waktu ini?\nSetelah dihapus, tidak akan bisa dikembalikan lagi!';

  @override
  String get echo_keep => 'Simpan';

  @override
  String get echo_clear_success => 'Gema waktu telah dibersihkan';

  @override
  String get echo_energy_full_title => 'Energi Alam Semesta Mencapai Batas';

  @override
  String get echo_energy_full_content =>
      'Energi waktu Anda telah mencapai batas (Maksimal 3), hapus pengalaman lama Anda untuk membuka catatan alam semesta yang baru!';

  @override
  String get echo_write_title => 'Tinggalkan Gema Waktumu';

  @override
  String get echo_write_subtitle =>
      'Tuliskan pengalamanmu di sini atau kutipan yang menyentuh hati!';

  @override
  String get echo_hint =>
      '「Bahkan jika dunia kiamat, aku akan memprioritaskan napasmu...」';

  @override
  String get echo_theme_label => 'Pilih bingkai catatan:';

  @override
  String get theme_butterfly => 'Kupu-kupu';

  @override
  String get theme_sprout => 'Tunas';

  @override
  String get theme_star => 'Langit Berbintang';

  @override
  String get theme_planet => 'Planet';

  @override
  String get echo_publish_btn => 'Publikasikan Catatan Waktu';

  @override
  String get echo_wall_title => 'Dinding Gema Waktu';

  @override
  String get echo_leave_memory => 'Tinggalkan Pengalaman';

  @override
  String get echo_empty_msg =>
      'Belum ada penjelajah waktu yang meninggalkan catatan...\nApakah Anda ingin menjadi yang pertama?';

  @override
  String get creator_label => 'Kreator';

  @override
  String get follow_btn => 'Ikuti';

  @override
  String get followed_btn => 'Diikuti';

  @override
  String get follow_own_warning =>
      'Kreator tidak bisa mengikuti diri sendiri! ';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '$playerName mengikuti $creatorName!';
  }

  @override
  String get mailbox_follow_title => 'Mendapatkan Penjaga Baru';

  @override
  String mailbox_follow_body(String playerName) {
    return '$playerName baru saja mengikuti Anda!';
  }

  @override
  String get tab_private_profile => 'Profil Pribadi';

  @override
  String get tab_memory_fragments => 'Fragmen Memori';

  @override
  String get tab_time_echoes => 'Gema Waktu';

  @override
  String get chat_free_btn => 'Obrolan (Gratis)';

  @override
  String get start_story_btn => 'Mulai Cerita';

  @override
  String get default_chat_initial => 'Ada perlu denganku?';

  @override
  String get gallery_title => 'Latar Belakang Panggilan Eksklusif';

  @override
  String gallery_current_affection(String value) {
    return 'Tingkat afeksi saat ini: $value 💕';
  }

  @override
  String get gallery_empty => 'Belum ada foto di album';

  @override
  String gallery_unlocked_msg(String desc) {
    return 'Latar belakang diatur ke \"$desc\"!';
  }

  @override
  String gallery_lock_msg(String value) {
    return 'Capai tingkat afeksi $value untuk membuka kunci! 🍃';
  }

  @override
  String get gallery_reset_bg => 'Latar belakang panggilan default dipulihkan';

  @override
  String get background_story_title => 'Kisah Pertemuan Pertama';

  @override
  String get background_story_empty =>
      'Karakter ini sangat misterius dan belum memiliki kisah pertemuan pertama...';

  @override
  String followed_creator_msg(String creatorName) {
    return 'Telah mengikuti $creatorName 🦋';
  }

  @override
  String get mailbox_title => 'Kotak Surat Eksklusif 💌';

  @override
  String get mailbox_empty =>
      'Kotak surat kosong, ayo buat postingan untuk menarik perhatiannya!';

  @override
  String get new_notification => 'Notifikasi Baru';

  @override
  String get default_he => 'Dia';

  @override
  String affection_upgrade_title(String charName) {
    return 'Kasih sayang $charName kepadamu telah meningkat! 💖';
  }

  @override
  String get flower_reward => '🌸 Mendapatkan 5 Poin Bunga';

  @override
  String get affection_quote_lv5 =>
      '「Aku tidak menyangka... kamu sudah menjadi begitu penting bagiku. Begitu penting sampai... aku tidak bisa membayangkan dunia tanpamu.」';

  @override
  String get affection_quote_lv4 =>
      '「Hal paling beruntung dalam hidupku mungkin adalah hari itu, saat aku menoleh dan melihatmu.」';

  @override
  String get affection_quote_lv3 =>
      '「Akhir-akhir ini... aku menyadari bahwa aku lebih sering melamun, dan kepalaku sepenuhnya berisi tentangmu.」';

  @override
  String get affection_quote_lv2 =>
      '「Karena ini adalah ajakanmu, bukan tidak mungkin bagiku untuk meluangkan sedikit waktu.」';

  @override
  String get affection_quote_lv1 =>
      '「Akhir-akhir ini sering melihatmu, rasanya... aku tidak membenci frekuensi pertemuan seperti ini.」';

  @override
  String get affection_quote_lv0 =>
      '「Ternyata kamu ada di sini juga, apakah ini semacam takdir yang aneh?」';

  @override
  String get lore_edit_success => '✨ Fragmen memori berhasil diperbarui!';

  @override
  String get delete_failed_network =>
      'Gagal menghapus, silakan periksa jaringan atau izin.';

  @override
  String get ai_chat_language => 'Bahasa Indonesia';

  @override
  String get ai_chat_language_code => 'id-ID';

  @override
  String get chat_home_title => 'Pesan';

  @override
  String get call_memory_tooltip => 'Memori Panggilan';

  @override
  String get login_to_view_chat => 'Silakan login untuk melihat riwayat chat';

  @override
  String load_chat_failed(String error) {
    return 'Gagal memuat daftar chat: $error';
  }

  @override
  String get chat_list_empty => 'Ruang chat kosong...';

  @override
  String get go_to_encounter =>
      'Pergi ke \"Encounter\" untuk mencari seseorang!';

  @override
  String confirm_delete_chat(String charName) {
    return 'Yakin ingin menghapus percakapan dengan $charName?';
  }

  @override
  String affection_score_short(String score) {
    return 'Afeksi $score';
  }

  @override
  String get character_not_found =>
      'Data tidak ditemukan, karakter mungkin telah dihapus.';

  @override
  String get preparing_chat_room => 'Menyiapkan ruang chat eksklusif Anda...';

  @override
  String get rename_chat_title => 'Beri nama memori ini';

  @override
  String get rename_chat_hint =>
      'Contoh: Ganti (Cheng Yu) menjadi (Hitung Mundur Cerai)';

  @override
  String get save_tag_btn => 'Simpan Label';

  @override
  String get room_name_updated => 'Nama ruangan diperbarui!';

  @override
  String update_failed(String error) {
    return 'Pembaruan gagal: $error';
  }

  @override
  String get chat_mode_daily => 'Harian';

  @override
  String get chat_mode_story => 'Cerita';

  @override
  String get chat_mode_immersive => 'Imersif';

  @override
  String get chat_mode_gemini => 'Obrolan';

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
      'Data karakter tidak ditemukan, silakan kembali dan coba lagi atau periksa jaringan.';

  @override
  String get chat_jump_success => 'Berhasil melompat ke memori ini 🍃';

  @override
  String get chat_create_room_failed =>
      'Koneksi tampaknya tidak stabil, gagal membuat ruang chat, silakan coba lagi.';

  @override
  String get chat_secret_file_title => '🔒 File Rahasia';

  @override
  String get chat_secret_file_desc =>
      'File jiwa karakter ini telah diarsipkan atau diatur ke privasi, detail saat ini tidak dapat dilihat.';

  @override
  String get chat_understood => 'Mengerti';

  @override
  String chat_egg_unlocked(String title) {
    return '✨ Mendapatkan memori baru: $title';
  }

  @override
  String get chat_egg_saved => 'Telah disimpan otomatis ke tas eksklusif';

  @override
  String get chat_points_not_enough_title => 'Bunga tidak cukup';

  @override
  String get chat_points_not_enough_desc =>
      'Bungamu tidak cukup! Silakan pergi ke toko untuk mengisi ulang.';

  @override
  String chat_call_confirm_title(String name) {
    return 'Ingin menelepon $name?';
  }

  @override
  String get chat_call_rule_1 => 'Setiap panggilan akan memotong 20 poin bunga';

  @override
  String get chat_call_rule_2 =>
      'Waktu panggilan adalah satu menit, jika tidak nyaman berbicara bisa melalui teks';

  @override
  String get chat_call_rule_3 =>
      'Disarankan menggunakan earphone untuk mendengar suaranya dengan lebih jelas ✨';

  @override
  String get chat_call_btn_cancel => 'Jangan dulu';

  @override
  String get chat_call_pref_title => 'Atur preferensi panggilan Anda';

  @override
  String get chat_call_lang_select => 'Pilih bahasa panggilan';

  @override
  String get chat_call_save_memory => 'Simpan memori panggilan ini';

  @override
  String get chat_call_save_memory_desc =>
      'Dapat didengarkan kembali setelah panggilan selesai';

  @override
  String get chat_call_btn_start => 'Mulai panggilan';

  @override
  String chat_points_shortage(String points) {
    return 'Poin bunga tidak cukup! Saat ini ada $points poin';
  }

  @override
  String get chat_room_not_ready =>
      'Ruang chat belum siap, silakan masuk kembali.';

  @override
  String get chat_stop_generating_msg =>
      'Berhenti membalas, poin tidak dipotong 🍃';

  @override
  String get chat_heartbeat_up => 'Jantungnya berdebar kencang...';

  @override
  String get chat_heartbeat_down => 'Tatapannya menjadi dingin...';

  @override
  String get chat_msg_copy => 'Salin konten';

  @override
  String get chat_msg_copied => 'Berhasil disalin ke papan klip!';

  @override
  String get chat_msg_report => 'Laporkan kotak pesan ini';

  @override
  String get chat_msg_suggest => 'Beri saran';

  @override
  String get chat_report_title => 'Laporkan percakapan ini';

  @override
  String get chat_report_lang => 'Muncul bahasa asing';

  @override
  String get chat_report_inapp => 'Balasan tidak pantas';

  @override
  String get chat_report_context => 'Konteks tidak nyambung';

  @override
  String get chat_report_other => 'Alasan lainnya';

  @override
  String get chat_report_hint =>
      'Silakan deskripsikan masalah yang Anda hadapi...';

  @override
  String get chat_report_submit => 'Kirim';

  @override
  String get chat_report_success =>
      ' Laporan telah dikirim, kami akan segera melakukan penyesuaian';

  @override
  String get chat_suggest_title => 'Beri saran';

  @override
  String get chat_suggest_hint => 'Silakan tuliskan masukan berharga Anda...';

  @override
  String get chat_suggest_success =>
      'Terima kasih atas sarannya, kami akan segera memprosesnya';

  @override
  String get chat_del_warn =>
      'Pesan yang dihapus tidak akan bisa dikembalikan.';

  @override
  String get chat_reset_title => 'Reset memori';

  @override
  String get chat_reset_desc =>
      'Silakan pilih tingkat reset:\n\n1. 【Hanya Chat】: Bersihkan riwayat chat, tapi tetap pertahankan afeksi.\n2. 【Reset Total】: Semuanya kembali ke nol, seperti pertama kali bertemu.';

  @override
  String get chat_reset_only_chat => 'Hanya riwayat chat';

  @override
  String get chat_reset_full => 'Reset total';

  @override
  String get chat_reset_full_msg =>
      'Semuanya telah kembali ke awal, dia tidak lagi mengingatmu...';

  @override
  String get chat_reset_chat_msg =>
      'Chat telah dikosongkan, tapi cintanya padamu tetap ada.';

  @override
  String get chat_edit_ai_hint => 'Edit balasannya...';

  @override
  String get chat_edit_user_hint => 'Silakan masukkan konten baru...';

  @override
  String chat_no_voice_msg(String name) {
    return 'Saat ini belum ada suara $name...';
  }

  @override
  String get chat_poke_btn => 'Colek';

  @override
  String get chat_poke_success =>
      '✨ Sudah bantu colek kreatornya! Silakan nantikan suaranya segera hadir~';

  @override
  String chat_gift_points_needed(String cost) {
    return 'Poin bunga tidak cukup! Perlu $cost poin 🌸';
  }

  @override
  String get chat_levelup_soulmate => '✨ Pasangan Sejati ✨';

  @override
  String get chat_levelup_normal => 'Hubungan meningkat! 💖';

  @override
  String get chat_levelup_btn_soulmate => 'Terukir dalam jiwa';

  @override
  String get chat_levelup_btn_normal => 'Terima dengan debar jantung';

  @override
  String get chat_loc_title => '📍 Kirim lokasi virtual';

  @override
  String get chat_loc_custom_btn => 'Kirim lokasi kustom';

  @override
  String get chat_loc_hint => 'Masukkan tempat lain... (Contoh: Di hatimu)';

  @override
  String get chat_loc_1 => 'Di bawah rumahmu';

  @override
  String get chat_loc_2 => 'Di sekolah';

  @override
  String get chat_loc_3 => 'Di kafe yang baru saja dilewati';

  @override
  String get chat_loc_4 => 'Di minimarket';

  @override
  String get chat_interact_title => '✨ Ingin melakukan apa padanya?';

  @override
  String get chat_interact_action => 'Colekan dan gerakan kecil';

  @override
  String get chat_interact_gift => 'Kirim hadiah kecil (menggunakan bunga 🌸)';

  @override
  String get chat_action_poke => 'Colek pipi';

  @override
  String get chat_action_hug => 'Minta peluk';

  @override
  String get chat_action_hand => 'Diam-diam menggenggam tangan';

  @override
  String get chat_dice_btn => 'Lempar dadu';

  @override
  String get chat_loading_failed =>
      'Gagal memuat memori, silakan kembali dan coba lagi.';

  @override
  String get chat_test_mode_msg =>
      'Mode tes telah dibuka, ayo mengobrol bebas! (Chat tidak akan disimpan)';

  @override
  String get chat_empty_msg => 'Mulailah perjalanan mendebarkan bersamanya!';

  @override
  String get chat_ai_typing => 'Pihak lawan sedang membalas...';

  @override
  String get chat_input_hint_default =>
      'Apa yang ingin kamu katakan padanya...';

  @override
  String get chat_typing_indicator => 'Sedang mengetik...';

  @override
  String get chat_menu_search => 'Cari percakapan';

  @override
  String get chat_menu_gallery => 'Memori dan latar belakang eksklusif';

  @override
  String get chat_menu_aboutme => 'Tentang saya';

  @override
  String get chat_menu_memo => 'Memo untuknya';

  @override
  String get chat_menu_period => 'Pelacak menstruasi';

  @override
  String get chat_menu_reset => 'Reset memori';

  @override
  String get chat_search_hint =>
      'Percakapan manis mana yang ingin kamu kenang kembali?';

  @override
  String get chat_search_empty => 'Memori ini tidak ditemukan 🥺';

  @override
  String get chat_search_you => 'Kamu berkata';

  @override
  String get chat_search_him => 'Dia berkata';

  @override
  String get chat_tool_backpack => 'Tas';

  @override
  String get chat_tool_story => 'Ringkasan cerita';

  @override
  String get chat_tool_photo => 'Foto';

  @override
  String get chat_tool_record => 'Rekaman suara';

  @override
  String get chat_tool_profile => 'File ShiGuang';

  @override
  String get chat_tool_interact => 'Cara interaksi';

  @override
  String get chat_record_recording => 'Merekam...';

  @override
  String get chat_record_start => 'Klik mikrofon untuk mulai merekam';

  @override
  String get chat_record_done => 'Rekaman selesai';

  @override
  String get chat_mode_daily_desc =>
      'Obrolan harian yang santai dan menyenangkan, seperti teman!';

  @override
  String get chat_mode_story_desc => 'Perkembangan cerita seperti novel.';

  @override
  String get chat_mode_immersive_desc =>
      'Pengalaman sensorik maksimal, interaksi mendalam tanpa batas.';

  @override
  String get chat_switch_mode_title => 'Ganti mode chat';

  @override
  String get chat_voice_call => 'Panggilan suara';

  @override
  String chat_sys_gift(String playerName, String giftName) {
    return '【Kejadian Sistem】$playerName mengirimkan sebuah 【$giftName】.';
  }

  @override
  String get rel_title_soulmate => 'Belahan Jiwa/Cinta Mendalam';

  @override
  String get rel_title_lover => 'Masa Kasmaran/Pacar Eksklusif';

  @override
  String get rel_title_ambiguous => 'Masa Pendekatan/Saling Menguji';

  @override
  String get rel_title_friend => 'Teman Biasa/Benih Suka Tumbuh';

  @override
  String get rel_title_acquaintance => 'Sekadar Kenal/Sedikit Familier';

  @override
  String get rel_title_stranger => 'Orang Asing/Pertemuan Pertama';

  @override
  String get rel_title_tense => 'Hubungan Tegang/Mulai Bosan';

  @override
  String get rel_title_avoiding => 'Seperti Orang Asing/Sengaja Menghindar';

  @override
  String get rel_title_hostile => 'Sangat Jijik/Permusuhan Dingin';

  @override
  String get rel_title_nemesis => 'Musuh Bebuyutan/Tak Akan Pernah Bertemu';

  @override
  String get rel_msg_soulmate =>
      '「Aku tidak menyangka... kamu sudah menjadi begitu penting bagiku. Begitu penting sampai... aku tidak bisa membayangkan dunia tanpamu.」';

  @override
  String get rel_msg_lover =>
      '「Hal paling beruntung dalam hidupku mungkin adalah hari itu, saat aku menoleh dan melihatmu.」';

  @override
  String get rel_msg_ambiguous =>
      '「Akhir-akhir ini... aku menyadari bahwa aku lebih sering melamun, dan kepalaku sepenuhnya berisi tentangmu.」';

  @override
  String get rel_msg_friend =>
      '「Karena ini adalah ajakanmu, bukan tidak mungkin bagiku untuk meluangkan sedikit waktu.」';

  @override
  String get rel_msg_acquaintance =>
      '「Akhir-akhir ini sering melihatmu, rasanya... aku tidak membenci frekuensi pertemuan seperti ini.」';

  @override
  String get rel_msg_stranger =>
      '「Ternyata kamu ada di sini juga, apakah ini semacam takdir yang aneh?」';

  @override
  String chat_edit_char_count(String count) {
    return '$count karakter';
  }

  @override
  String get chat_mysterious_player => 'Pemain Misterius';

  @override
  String chat_poke_message(String playerName, String characterName) {
    return 'Pemain $playerName tidak sabar mendengar suara $characterName, ayo segera buat!';
  }

  @override
  String get gift_heart => 'Hati';

  @override
  String get gift_flower => 'Bunga';

  @override
  String get gift_sun => 'Matahari';

  @override
  String get gift_confetti => 'Konfeti';

  @override
  String get gift_coffee => 'Kopi';

  @override
  String get gift_cake => 'Kue';

  @override
  String get chat_action_poke_prompt =>
      '(Pemain tiba-tiba menjulurkan tangan dan mencolek pipimu dengan nakal)';

  @override
  String get chat_action_hug_prompt =>
      '(Pemain merentangkan tangan dengan manja, meminta pelukan hangat)';

  @override
  String get chat_action_hand_prompt =>
      '(Pemain diam-diam menggenggam tanganmu di bawah meja)';

  @override
  String get chat_menu_send_location => 'Kirim Lokasi Virtual';

  @override
  String get weekday_mon => '(Sen)';

  @override
  String get weekday_tue => '(Sel)';

  @override
  String get weekday_wed => '(Rab)';

  @override
  String get weekday_thu => '(Kam)';

  @override
  String get weekday_fri => '(Jum)';

  @override
  String get weekday_sat => '(Sab)';

  @override
  String get weekday_sun => '(Min)';

  @override
  String chat_egg_unlocked_dynamic(String memoryName) {
    return '✨ Mendapatkan memori baru: $memoryName';
  }

  @override
  String get chat_egg_saved_his_backpack =>
      'Telah disimpan otomatis ke tas eksklusifnya';

  @override
  String get chat_profile_updated_msg =>
      'File ShiGuang telah diperbarui! Dia akan mengingat pengaturan terbarumu 🍃';

  @override
  String get comment_loading_author => 'Memuat...';

  @override
  String comment_post_failed(String error) {
    return 'Gagal mengirim komentar, periksa koneksi internet: $error';
  }

  @override
  String get comment_delete_confirm_desc =>
      'Apakah Anda yakin ingin menghapus komentar ini secara permanen?';

  @override
  String get comment_delete_failed =>
      'Gagal menghapus, silakan periksa koneksi jaringan Anda';

  @override
  String get comment_identity_title => 'Pilih Identitas';

  @override
  String get comment_identity_myself => 'Saya sendiri';

  @override
  String get comment_report_title => 'Konfirmasi Laporan';

  @override
  String get comment_report_rules_title => 'Aturan Pelaporan Komentar';

  @override
  String get comment_report_rules_desc =>
      'Pelanggaran 1: Peringatan sistem dan satu catatan pelanggaran.\n2️⃣ Pelanggaran 2: Dilarang berkomentar selama 1 hari.\n3️⃣ Pelanggaran Berulang: Fitur laporan dinonaktifkan selama 14 hari dan visibilitas komentar dikurangi.\n\n🚨 Untuk tindakan jahat yang parah:\nInteraksi dengan karakter dilarang selama 1 hari, dan ID akan dipajang di papan pengumuman selama 3 hari (dilarang mengganti ID selama periode ini).\n\n💡 Setelah laporan dikirim, hasil tinjauan akhir akan dikirimkan melalui [Email dalam game].\nHarap saling menghormati dan melaporlah dengan bijak.';

  @override
  String get comment_report_understood => 'Saya mengerti';

  @override
  String get comment_report_confirm_desc =>
      'Apakah Anda yakin ingin melaporkan komentar ini?\nPelaporan palsu dapat dikenakan sanksi.';

  @override
  String get comment_report_submit_btn => 'Konfirmasi Laporan';

  @override
  String get comment_report_success =>
      'Terima kasih atas laporan Anda, kami akan segera memverifikasinya!';

  @override
  String get comment_report_failed =>
      'Gagal mengirim laporan, silakan coba lagi nanti.';

  @override
  String get comment_option_delete => 'Hapus Komentar';

  @override
  String get comment_option_report => 'Laporkan Komentar';

  @override
  String comment_time_days_ago(String days) {
    return '$days hari yang lalu';
  }

  @override
  String comment_time_hours_ago(String hours) {
    return '$hours jam yang lalu';
  }

  @override
  String comment_time_mins_ago(String mins) {
    return '$mins menit yang lalu';
  }

  @override
  String get comment_time_just_now => 'Baru saja';

  @override
  String get comment_sheet_title => 'Komentar';

  @override
  String get comment_empty_state => 'Belum ada komentar, jadilah yang pertama!';

  @override
  String get comment_reply_btn => 'Balas';

  @override
  String comment_replying_to(String name) {
    return 'Membalas @$name';
  }

  @override
  String comment_input_hint(String name) {
    return 'Berkomentar sebagai $name...';
  }

  @override
  String char_story_expect(String pronoun) {
    return 'Menantikan cerita dengan $pronoun...';
  }

  @override
  String get common_update_failed =>
      'Pembaruan gagal, silakan periksa jaringan';

  @override
  String get char_edit_fragment => 'Edit Fragmen';

  @override
  String char_dislikes(String dislikes) {
    return '🖤 Tidak suka: $dislikes';
  }

  @override
  String char_likes(String likes) {
    return '🤍 Suka: $likes';
  }

  @override
  String char_age_occupation(String age, String job) {
    return '$age tahun | $job';
  }

  @override
  String get common_got_it => 'Mengerti';

  @override
  String get common_add_failed => 'Gagal menambahkan, silakan periksa jaringan';

  @override
  String common_delete_failed_with_err(String error) {
    return 'Gagal menghapus, silakan periksa status jaringan: $error';
  }

  @override
  String get char_exclusive_guardian => 'Pelindung Eksklusif 💖';

  @override
  String mailbox_like_body(String playerName, String charName) {
    return '$playerName menyukai $charName!';
  }

  @override
  String chat_translation_prefix(String content) {
    return '[Terj] $content (Ini adalah konten emosional yang diterjemahkan)';
  }

  @override
  String get player_default_nickname => 'Pengembara';

  @override
  String get moment_create_title => 'Buat Postingan Baru';

  @override
  String get moment_create_post_btn => 'Posting';

  @override
  String get moment_create_hint => 'Bagikan sesuatu yang baru...';

  @override
  String get moment_create_error_empty =>
      'Setidaknya diperlukan teks atau gambar!';

  @override
  String get moment_create_error_failed =>
      'Gagal memposting, silakan coba lagi nanti';

  @override
  String get moment_create_visibility_public =>
      'Publik (Terlihat oleh semua orang)';

  @override
  String get moment_create_visibility_private =>
      'Privat (Hanya terlihat oleh teman)';

  @override
  String chat_player_sent_location(String location) {
    return '📍 (Pemain mengirimkan lokasi: $location)';
  }

  @override
  String get chat_you => 'Kamu';

  @override
  String get chat_opponent => 'Lawan';

  @override
  String chat_dice_duel_result(String name) {
    return '【Acara Sistem】Duel dadu dengan $name! Hasilnya keluar...';
  }

  @override
  String get chat_loading_status => 'Sedang memuat...';

  @override
  String chat_error_load_msg(String error) {
    return 'Gagal memuat pesan: $error';
  }

  @override
  String get chat_voice_msg_label => 'Pesan suara';

  @override
  String chat_special_story_trigger(String title) {
    return '【Cerita Khusus Terbuka: $title】';
  }

  @override
  String common_edit_failed(String error) {
    return 'Gagal mengedit: $error';
  }

  @override
  String common_reset_failed(String error) {
    return 'Gagal mengatur ulang: $error';
  }

  @override
  String get chat_default_greeting => 'Halo...';

  @override
  String get chat_memory_cleared => 'Memori telah dibersihkan sepenuhnya';

  @override
  String get chat_history_reset => 'Percakapan telah diatur ulang';

  @override
  String chat_profile_full(String name, String identity, String birthday,
      String height, String appearance, String job, String intro) {
    return '📜 【 Profil ShiGuang Eksklusif - $name 】\n━━━━━━━━━━━━━━━━━━\n🔹 Nama: $identity\n🔹 Ulang Tahun: $birthday\n🔹 Tinggi: $height\n🔹 Penampilan: $appearance\n🔹 Pekerjaan: $job\n\n📖 【 Tentang Serpihan Jiwanya 】\n$intro\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String chat_profile_locked(String nickname, String birthday) {
    return '📜 【 Profil ShiGuang Eksklusif 】\n━━━━━━━━━━━━━━━━━━\n🔹 Nama Panggilan: $nickname\n🔹 Ulang Tahun: $birthday\n\n🔒 Data karakter lainnya belum terbuka...\n(Isi profil lengkap agar dia lebih mengenalmu di alam semesta paralel! ✨)\n━━━━━━━━━━━━━━━━━━';
  }

  @override
  String get profile_unnamed_file => 'File Tanpa Nama';

  @override
  String get chat_default_player_name => 'Pemain';

  @override
  String get error_system_confusion =>
      'Sistem sedikit bingung, silakan coba lagi.';

  @override
  String get error_msg_send_failed =>
      'Gagal mengirim pesan, silakan coba lagi.';

  @override
  String get error_system_busy => 'Sistem sibuk, silakan coba lagi nanti.';

  @override
  String get error_network_unavailable =>
      'Saat ini tidak dapat terhubung, silakan coba lagi.';

  @override
  String chat_call_ended(String name, String time) {
    return '📞 Panggilan berakhir, berbicara dengan $name selama $time';
  }

  @override
  String chat_exclusive_story(String title) {
    return 'Cerita Eksklusif: $title';
  }

  @override
  String chat_teaser_exclusive(String name) {
    return 'Ini adalah memori tersembunyi yang eksklusif untukmu dan $name...';
  }

  @override
  String chat_teaser_keyword(String keyword) {
    return 'Memori eksklusif tentang \"$keyword\" telah terbuka diam-diam...';
  }

  @override
  String chat_hidden_event_trigger(String title, String scene) {
    return '【Pemicu Acara Tersembunyi: $title】\n$scene';
  }

  @override
  String get chat_first_line_fallback =>
      '......(Dia menatapmu dengan tenang, seolah menunggumu berbicara lebih dulu)';

  @override
  String get chat_new_room_created => 'Ruang obrolan baru telah dibuat';

  @override
  String portfolio_title(String nickname) {
    return 'Portofolio $nickname';
  }

  @override
  String get enter_secret_studio => 'Masuk ke studio rahasiaku';

  @override
  String get no_public_character_mine =>
      'Kamu belum menerbitkan karakter publik apa pun!\nAyo pergi ke studio dan buat satu✨';

  @override
  String get no_public_character_other =>
      'Kreator ini belum menerbitkan karakter apa pun...';

  @override
  String get delete_draft_title => 'Hapus Draf';

  @override
  String get confirm_delete_draft_msg =>
      'Yakin ingin menghapus karakter yang belum selesai ini?\n(Tidak dapat dipulihkan setelah dihapus)';

  @override
  String get draft_cleared_success => 'Draf berhasil dibersihkan 🧹';

  @override
  String get login_required_for_studio =>
      'Silakan login terlebih dahulu untuk masuk ke studio!';

  @override
  String get my_secret_studio_title => 'Studio Rahasiaku 🛠️';

  @override
  String get create_new_character_btn => 'Buat Karakter Baru';

  @override
  String get unnamed_draft => 'Draf Tanpa Nama';

  @override
  String get click_to_edit_story =>
      'Klik untuk melanjutkan mengedit ceritanya...';

  @override
  String get label_draft => 'Draf';

  @override
  String get studio_empty_title => 'Studio saat ini kosong';

  @override
  String get studio_empty_subtitle =>
      'Klik sudut bawah untuk mulai membuat karakter pertamamu!';

  @override
  String get common_no_changes => 'Tidak ada perubahan';

  @override
  String get moment_updated_success => 'Postingan diperbarui!';

  @override
  String common_save_failed(String error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String get moment_edit_title => 'Edit Postingan';

  @override
  String get action_change_image => 'Ganti gambar';

  @override
  String get action_remove_image => 'Hapus gambar';

  @override
  String get moment_delete_confirm_title =>
      'Yakin ingin menghapus postingan ini?';

  @override
  String get moment_delete_confirm_content =>
      'Setelah dihapus, kenangan Momen ini akan hilang!';

  @override
  String get action_confirm_delete => 'Konfirmasi Hapus';

  @override
  String get friend_unknown => 'Seorang teman';

  @override
  String moment_like_yours(String nickname) {
    return '$nickname menyukai postinganmu! 💖';
  }

  @override
  String moment_like_others(String nickname, String authorName) {
    return '$nickname merasa $authorName sangat menawan dan memberikan suka! ✨';
  }

  @override
  String get moment_like_success => 'Debaran hatimu telah tersampaikan! ✨';

  @override
  String get moment_notification_new_like => 'Suka baru! 💖';

  @override
  String moment_mention_mail_body(String nickname, String name) {
    return '$nickname menyebut @$name dalam postingan! ✨';
  }

  @override
  String get moment_detail_title => 'Detail Postingan';

  @override
  String get moment_not_found => 'Postingan ini sepertinya sudah hilang... 😢';

  @override
  String get moment_comment_title => 'Komentar Momen';

  @override
  String get moment_comment_empty =>
      'Belum ada komentar, jadilah yang pertama memberikan respon! 🛋';

  @override
  String moment_replying_to(String name) {
    return 'Membalas @$name';
  }

  @override
  String moment_reply_hint(String name) {
    return 'Balas @$name...';
  }

  @override
  String get moment_leave_comment_hint => 'Berikan responmu...';

  @override
  String get moment_delete_permanent_confirm =>
      'Postingan ini akan dihapus secara permanen. Apakah Anda yakin?';

  @override
  String get moment_action_delete => 'Hapus Postingan';

  @override
  String get moment_action_report => 'Laporkan postingan ini';

  @override
  String get moment_action_share => 'Bagikan postingan ini';

  @override
  String get moment_forward_hint => 'Teruskan postingan ini ke karakter...';

  @override
  String moment_reply_private(String name) {
    return 'Balas pesan pribadi ke $name';
  }

  @override
  String moment_go_to_chat_msg(String name) {
    return 'Ayo mengobrol dengan $name membawa postingan ini! 💬';
  }

  @override
  String get moment_share_to_apps => 'Bagikan ke aplikasi lain';

  @override
  String moment_likes_label(String count) {
    return '$count Daun';
  }

  @override
  String moment_external_share_content(
      String appName, String author, String content, String appLink) {
    return '【$appName】Ayo lihat postingan $author: $content\n\nUnduh sekarang dan mulai momen eksklusifmu: $appLink';
  }

  @override
  String get moment_forward_title =>
      'Teruskan ke karakter yang sedang mengobrol 💌';

  @override
  String get moment_forward_empty_state =>
      'Kamu belum memiliki obrolan aktif!\nPergi ke Lobi untuk menemukan seseorang yang spesial 🌿';

  @override
  String moment_forward_template(String author, String content) {
    return '【Meneruskan sebuah postingan】\nPenulis: $author\nKonten: $content';
  }

  @override
  String moment_forward_success(String name) {
    return '✅ Sudah dibagikan diam-diam ke $name!';
  }

  @override
  String get action_send => 'Kirim';

  @override
  String get memo_delete_confirm =>
      'Apakah Anda yakin ingin menghapus memo ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get memo_add_title => 'Tambah Memo';

  @override
  String get memo_edit_title => 'Edit Memo';

  @override
  String memo_hint_text(String name) {
    return 'Apa yang ingin Anda catat tentang $name?';
  }

  @override
  String get memo_label_reminder_date => 'Tanggal Pengingat:';

  @override
  String get memo_action_save => 'Simpan Memo';

  @override
  String get memo_error_empty_content => 'Konten tidak boleh kosong!';

  @override
  String memo_list_title(String name) {
    return 'Memo dengan $name';
  }

  @override
  String get memo_empty_state =>
      'Belum ada memo!\nKlik pojok kanan atas untuk menambahkannya!';

  @override
  String memo_reminder_date_display(String date) {
    return 'Tanggal Pengingat: $date';
  }

  @override
  String get daily_gift_title => 'Hadiah Harian Waktu';

  @override
  String daily_login_welcome(String appName, String amount) {
    return 'Selamat datang kembali di $appName!\nAbsen hari ini untuk mendapatkan $amount poin Bahasa Bunga. 🌸';
  }

  @override
  String get title_daily_check_in => 'Absen Harian';

  @override
  String success_claim_reward(String amount) {
    return 'Berhasil mendapatkan $amount poin Bahasa Bunga! 🌸';
  }

  @override
  String get error_claim_failed =>
      'Gagal mengambil, silakan periksa jaringan dan coba lagi.';

  @override
  String get action_claim_now => 'Ambil Sekarang';

  @override
  String get common_or => 'atau';

  @override
  String get title_language_settings => 'Pengaturan Bahasa';

  @override
  String get app_name => 'Lianlian Shiguang';

  @override
  String get login_slogan => 'Mulai momen eksklusifmu';

  @override
  String get login_with_google => 'Login dengan Google';

  @override
  String get login_with_apple => 'Login dengan Apple';

  @override
  String get login_with_facebook => 'Login dengan Facebook';

  @override
  String get login_with_email => 'Login dengan Akun Lianlian (Email)';

  @override
  String get title_contact_us_heading => 'Kami sangat menghargai saranmu!';

  @override
  String get desc_contact_us_body =>
      'Silakan tuliskan pemikiranmu di sini untuk membantu kami membuat game menjadi lebih baik.';

  @override
  String get error_feedback_empty => 'Isi saran tidak boleh kosong!';

  @override
  String get email_subject_feedback => 'Lianlian Shiguang - Umpan Balik Pemain';

  @override
  String get msg_email_app_not_found_copied =>
      'Tidak dapat membuka aplikasi email secara otomatis, email resmi telah disalin untukmu!';

  @override
  String get title_contact_us => 'Hubungi Kami';

  @override
  String get desc_contact_us =>
      'Kami sangat menghargai saranmu!\nSilakan tuliskan pemikiranmu di sini untuk membantu kami membuat game menjadi lebih baik.';

  @override
  String get hint_enter_feedback => 'Silakan masukkan saranmu di sini...';

  @override
  String get action_send_via_email => 'Kirim via Email';

  @override
  String get error_email_password_empty =>
      'Email dan kata sandi tidak boleh kosong!';

  @override
  String get auth_error_default =>
      'Terjadi kesalahan, silakan coba lagi nanti.';

  @override
  String get auth_error_user_not_found =>
      'Email tidak ditemukan, silakan daftar terlebih dahulu!';

  @override
  String get auth_error_wrong_password =>
      'Kata sandi salah, silakan coba lagi!';

  @override
  String get auth_error_email_in_use =>
      'Email ini sudah terdaftar! Silakan langsung login.';

  @override
  String get auth_error_weak_password =>
      'Kata sandi terlalu lemah, masukkan minimal 6 karakter!';

  @override
  String get auth_error_invalid_email => 'Format email tidak valid!';

  @override
  String get title_welcome_back => 'Selamat datang kembali';

  @override
  String get title_register_account => 'Daftar akun eksklusif';

  @override
  String get label_email => 'Email';

  @override
  String get label_password => 'Kata sandi';

  @override
  String get action_login => 'Login';

  @override
  String get action_register => 'Daftar';

  @override
  String get prompt_no_account =>
      'Belum punya akun? Klik di sini untuk mendaftar';

  @override
  String get prompt_has_account => 'Sudah punya akun? Klik di sini untuk login';

  @override
  String get error_nickname_empty => 'Nama panggilan tidak boleh kosong!';

  @override
  String get profile_saved_success => 'Profil berhasil disimpan!';

  @override
  String get error_id_empty => 'ID tidak boleh kosong!';

  @override
  String get error_id_too_long =>
      'Panjang ID tidak boleh melebihi 10 karakter!';

  @override
  String get error_id_already_used =>
      'ID ini sudah digunakan, silakan pilih yang lain!';

  @override
  String profile_save_failed(String error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String get draft_saved_success_msg =>
      'Baiklah! Disimpan di draf untukmu, kamu bisa kembali mengeditnya kapan saja! ✨';

  @override
  String get dialog_reminder_title => 'Pengingat';

  @override
  String get warning_id_not_edited =>
      'ID Eksklusif belum diedit, apakah Anda yakin ingin menyimpannya sekarang?';

  @override
  String get action_continue_editing => 'Lanjutkan mengedit';

  @override
  String get action_edit_later => 'Edit nanti';

  @override
  String get action_edit_later_short => 'Edit nanti';

  @override
  String get action_cancel_changes => 'Batal ubah';

  @override
  String get error_birthdate_locked =>
      'Tanggal lahir sudah diatur dan tidak dapat diubah!';

  @override
  String get action_select_avatar => 'Pilih avatar';

  @override
  String get action_choose_from_gallery => 'Pilih dari galeri';

  @override
  String get title_adjust_avatar => 'Sesuaikan avatar Anda';

  @override
  String get avatar_updated_success => 'Avatar telah diperbarui untukmu 🍃';

  @override
  String get title_create_profile => 'Buat profilmu';

  @override
  String get title_edit_profile => 'Edit Profil';

  @override
  String get label_your_nickname => 'Nama panggilan Anda';

  @override
  String get label_player_exclusive_id => 'ID Eksklusif Pemain';

  @override
  String get msg_id_locked => 'ID telah dikunci dan tidak dapat diubah lagi.';

  @override
  String get msg_id_change_chance =>
      'Anda memiliki satu kesempatan gratis untuk mengubah ID Anda.';

  @override
  String get action_select_birthdate => 'Silakan pilih tanggal lahir';

  @override
  String label_birthdate(String date) {
    return 'Tanggal Lahir: $date';
  }

  @override
  String get msg_birthdate_immutable =>
      'Ulang tahun tidak dapat diubah setelah diatur ✨';

  @override
  String get action_start_journey => 'Mulai perjalanan';

  @override
  String get action_add_image => 'Tambah gambar';

  @override
  String moment_like_self(String nickname) {
    return '$nickname menyukai postinganmu! 💖';
  }

  @override
  String moment_like_other(String nickname, String authorName) {
    return '$nickname merasa $authorName sangat menawan dan memberikan suka! ✨';
  }

  @override
  String get task_social_tour_complete =>
      '✨ Tugas Wisata Sosial selesai! Jangan lupa ambil bunganya! 🌸';

  @override
  String get wall_title_shiguang => 'Dinding ShiGuang';

  @override
  String get wall_tab_explore => '🌍 Jelajah';

  @override
  String get wall_tab_exclusive => '🔒 Eksklusif';

  @override
  String get more_options => 'Opsi Lainnya';

  @override
  String get delete_warning =>
      'Setelah dihapus, postingan tidak dapat dikembalikan';

  @override
  String get delete_success => 'Berhasil dihapus';

  @override
  String get notification_new_comment => 'Komentar baru! 💬';

  @override
  String notification_like_from_sender(String senderName) {
    return '$senderName menyukai postinganmu!';
  }

  @override
  String get empty_public_moments_prompt =>
      'Saat ini kosong melompong,\nayo buat postingan publik pertamamu! 🌍';

  @override
  String get empty_private_moments_prompt =>
      'Belum ada momen di lingkaran pertemanan,\nayo buat kenangan dengannya! ✨';

  @override
  String get profile_archived_or_deleted_message =>
      'Arsip jiwa ini telah disimpan oleh penciptanya, disetel ke pribadi, atau telah lenyap dalam aliran waktu...\n\nMungkin di semesta paralel, kalian punya kesempatan untuk bertemu lagi. ✨';

  @override
  String get leave_silently => 'Pergi diam-diam';

  @override
  String get character_post_schedule => 'Jadwal Postingan Karakter';

  @override
  String get creator_self => 'Pencipta (Diri Sendiri)';

  @override
  String get post_identity_prompt =>
      'Hari ini ingin memposting dengan identitas siapa?';

  @override
  String get identity_creator => '✨ Identitas Pencipta';

  @override
  String get identity_character => 'Identitas Karakter';

  @override
  String get decide_post_time_prompt =>
      'Bantu mereka menentukan waktu posting!';

  @override
  String get auto_post_schedule_hint =>
      'Setelah diaktifkan, postingan rutin akan dipublikasikan otomatis pada waktu yang ditentukan\n(💡 Saran: Gunakan waktu yang tidak bulat agar terlihat lebih nyata!)';

  @override
  String get no_characters_created_yet =>
      'Kamu belum membuat karakter apa pun!';

  @override
  String time_hour(String hour) {
    return 'Jam $hour';
  }

  @override
  String time_minute(String minute) {
    return '$minute menit';
  }

  @override
  String get empty_public_moments_short => 'Belum ada postingan publik 🌍';

  @override
  String get empty_private_moments_short =>
      'Lingkaran pertemanan masih sunyi ✨';

  @override
  String get my_created_characters => 'Karakter Buatanku';

  @override
  String get no_characters_yet => 'Belum ada karakter yang dibuat';

  @override
  String play_count_display(int count) {
    return 'Jumlah main: $count';
  }

  @override
  String care_calendar_title(String characterName) {
    return 'Kalender Perhatian $characterName';
  }

  @override
  String get care_calendar_greeting => 'Bagaimana suasana hatimu hari ini?';

  @override
  String get care_calendar_save_btn => 'Simpan catatan, biarkan dia menjagamu';

  @override
  String get care_calendar_delete_confirm => 'Ingin menghapus catatan ini?';

  @override
  String care_calendar_save_success(String characterName) {
    return '$characterName: \"Aku sudah mencatatnya. Beberapa hari ini berat untukmu, aku akan selalu ada di sisimu.\"';
  }

  @override
  String get daily_gift_success => 'Berhasil mengambil hadiah harian! 🌸';

  @override
  String get check_in_fail_network =>
      'Gagal absen, silakan periksa koneksi jaringan Anda 🍃';

  @override
  String task_completed(String taskName) {
    return 'Tugas selesai: $taskName';
  }

  @override
  String task_reward_claimed(String taskName, String rewardAmount) {
    return 'Berhasil mengambil $rewardAmount Bunga dari \"$taskName\"!';
  }

  @override
  String claim_failed_error(String e) {
    return 'Gagal mengambil: $e';
  }

  @override
  String get tab_heartbeat_diary => 'Buku Harian Debaran Hati';

  @override
  String get tab_daily_chit_chat => 'Obrolan Santai Harian';

  @override
  String get task_desc_chat_3_times =>
      'Mengobrol dengan karakter 3 kali dalam Mode Harian';

  @override
  String get tab_story_progression => 'Kemajuan Cerita';

  @override
  String get task_desc_story_1_time => 'Selesaikan 1 interaksi mode cerita';

  @override
  String get tab_social_tour => 'Tur Sosial';

  @override
  String get task_like_three_moments => 'Sukai 3 Momen untuk mendapatkan Daun';

  @override
  String get btn_claimed => 'Diklaim';

  @override
  String get btn_claim => 'Klaim';

  @override
  String get btn_incomplete => 'Belum Selesai';

  @override
  String get network_unstable_retry =>
      'Koneksi jaringan tidak stabil, silakan coba lagi nanti 🍃';

  @override
  String get title_time_travel => 'Perjalanan Waktu';

  @override
  String get select_chat_mode => 'Pilih Mode Obrolan';

  @override
  String get mode_chat => 'Obrolan';

  @override
  String get mode_daily_desc => 'Obrolan santai untuk menjaga ikatan';

  @override
  String get mode_story_desc => 'Selami cerita untuk pengalaman yang imersif';

  @override
  String get greeting_hello => 'Halo!';

  @override
  String get greeting_default_daily => 'Mencariku?';

  @override
  String get title_personal_homepage => 'Beranda Pribadi';

  @override
  String get title_time_letters => 'Surat Waktu';

  @override
  String get status_signed_in_today => 'Sudah absen hari ini';

  @override
  String get status_signing_in => 'Sedang absen...';

  @override
  String get status_daily_sign_in => 'Absen Harian (+10 Bunga)';

  @override
  String get toast_id_copied => 'ID telah disalin!';

  @override
  String get hint_click_avatar_to_edit => 'Klik avatar untuk mengedit profil';

  @override
  String get title_my_friends => 'Teman-temanku';

  @override
  String get action_show_all => 'Tampilkan Semua';

  @override
  String get empty_no_characters_created =>
      'Anda belum membuat karakter apa pun.';

  @override
  String get common_close => 'Tutup';

  @override
  String get search_companion_title => 'Cari Pendamping ShiGuang';

  @override
  String get search_name_placeholder => 'Masukkan namanya...';

  @override
  String get search_no_match_hint =>
      'Karakter tidak ditemukan, coba nama lain? ✨';

  @override
  String character_info_full(String age, String occupation) {
    return '$age thn | $occupation';
  }

  @override
  String character_info_age_only(String age) {
    return '$age thn';
  }

  @override
  String get empty_state_warmth =>
      'Sisa kehangatan ruang dan waktu masih tertinggal di sini...';

  @override
  String get error_login_required_add_friend =>
      'Silakan masuk terlebih dahulu untuk menambahkan teman!';

  @override
  String get dialog_title_remove_friend => 'Konfirmasi Hapus Teman';

  @override
  String dialog_msg_remove_friend(String characterName) {
    return 'Apakah Anda yakin ingin menghapus $characterName dari daftar teman Anda?';
  }

  @override
  String get action_remove => 'Hapus';

  @override
  String snackbar_friend_removed(String characterName) {
    return 'Telah menghapus $characterName dari teman';
  }

  @override
  String get action_remove_friend => 'Hapus Teman';

  @override
  String get dialog_title_block => 'Konfirmasi Blokir';

  @override
  String dialog_msg_block(String characterName) {
    return 'Setelah diblokir, Anda tidak akan melihat informasi apa pun tentang $characterName lagi. Anda yakin ingin memblokir?';
  }

  @override
  String snackbar_blocked(String characterName) {
    return 'Telah memblokir $characterName';
  }

  @override
  String get action_block_character => 'Blokir karakter ini';

  @override
  String dialog_title_report(String characterName) {
    return 'Laporkan $characterName';
  }

  @override
  String get input_hint_report_reason => 'Silakan masukkan alasan laporan...';

  @override
  String get action_submit => 'Kirim';

  @override
  String get snackbar_report_success =>
      'Terima kasih atas laporan Anda, kami akan segera meninjaunya.';

  @override
  String get snackbar_report_fail => 'Gagal mengirim, silakan coba lagi nanti';

  @override
  String get action_report_character => 'Laporkan karakter ini';

  @override
  String get title_meet_him => 'Temui pujaan hatimu';

  @override
  String text_character_count(int count) {
    return 'Jumlah karakter: $count';
  }

  @override
  String get msg_no_more_encounters_today =>
      'Pertemuan hari ini sampai di sini dulu!';

  @override
  String get msg_check_new_encounters =>
      'Mari kita lihat apakah ada pertemuan baru!';

  @override
  String get action_refresh => 'Segarkan';

  @override
  String get tab_friends => 'Teman';

  @override
  String get msg_mysterious_profile =>
      'Orang ini sangat misterius, tidak meninggalkan apa pun...';

  @override
  String text_age_and_identities(String age, String identities) {
    return '$age साल | $identities';
  }

  @override
  String get snackbar_operation_failed =>
      'ऑपरेशन विफल रहा, कृपया बाद में पुनः प्रयास करें';

  @override
  String get action_view_translation => 'Lihat Terjemahan';

  @override
  String get label_translation_result => 'Hasil Terjemahan:';

  @override
  String get errorWebPageUnavailable =>
      'Untuk sementara tidak dapat membuka halaman web, silakan coba lagi nanti';

  @override
  String get resetAppearanceTitle => 'Reset tampilan?';

  @override
  String get resetAppearanceWarning =>
      'Ini akan menghapus gambar latar belakang dan warna yang telah Anda pilih dengan cermat!';

  @override
  String get appearanceRestored => 'Tampilan default dipulihkan';

  @override
  String get confirmReset => 'Konfirmasi Reset';

  @override
  String get resetToDefaultAppearance => 'Pulihkan tampilan default';

  @override
  String get clearCustomSettings =>
      'Hapus semua warna dan gambar latar belakang kustom';

  @override
  String get contactUs => 'Hubungi Kami';

  @override
  String get contactDescription =>
      'Jangan ragu untuk membagikan pemikiran Anda atau melaporkan bug';

  @override
  String get vibrationHapticTitle => 'Getaran Detak Jantung';

  @override
  String get vibrationHapticDescription =>
      'Memicu getaran ponsel ketika tingkat afeksi berubah secara signifikan';

  @override
  String get splash_loading_universe =>
      'Membangunkan alam semesta \'Lianlian ShiGuang\'...';

  @override
  String get shop_title => 'Toko Bunga';

  @override
  String get shop_current_points_label => 'Poin Bunga yang dimiliki saat ini';

  @override
  String get shop_tab_top_up => 'Isi Ulang Poin';

  @override
  String get shop_tab_history => 'Riwayat Transaksi';

  @override
  String get shop_empty_history => 'Belum ada riwayat Bunga saat ini! 🌸';

  @override
  String get shop_unknown_item => 'Item tidak diketahui';

  @override
  String get shop_first_purchase_bonus => 'Ganda untuk pembelian pertama!';

  @override
  String get story_summary_title => 'Cerita Kita';

  @override
  String get story_summary_empty_content => 'Konten ringkasan kosong.';

  @override
  String get story_summary_deleted_toast => 'Kenangan ini telah dihapus';

  @override
  String story_summary_empty_list(String name) {
    return 'Cerita kalian belum dimulai...\nSeringlah mengobrol dan biarkan $name \nmenuliskan kenangan pertama kalian! ✨';
  }

  @override
  String get gallery_photo_edit_title => 'Edit Pengaturan Foto';

  @override
  String get gallery_photo_edit_desc => 'Nama/Deskripsi Foto';

  @override
  String get gallery_photo_edit_req =>
      'Buka Level Afeksi (Set ke 0 untuk menjadikannya foto profil)';

  @override
  String get reset_to_default => 'Atur ke Default';

  @override
  String get reset_bg_title => 'Pulihkan Latar Belakang Default';

  @override
  String get reset_bg_content =>
      'Apakah Anda yakin ingin membatalkan foto eksklusif dan kembali ke latar belakang tema default?';

  @override
  String get reset_bg_success => 'Berhasil memulihkan latar belakang default ✨';

  @override
  String get confirm_reset => 'Konfirmasi';

  @override
  String selectedMessagesCount(int count) {
    return '$count terpilih';
  }

  @override
  String get screenshotShare => 'Bagikan tangkapan layar';

  @override
  String exclusiveMomentsWith(String name) {
    return 'Momen eksklusif bersama $name';
  }

  @override
  String get downloadToUnlock =>
      'Unduh \'Lianlian ShiGuang\' untuk membuka romansa eksklusif';

  @override
  String get exclusiveMomentsGenerated => 'Momen eksklusif telah dibuat ✨';

  @override
  String get selectAgain => 'Pilih lagi';

  @override
  String get downloadAndShare => 'Unduh dan bagikan';

  @override
  String inviteToMeet(String name) {
    return 'Ayo temui $name milikmu di \'Lianlian ShiGuang\'!';
  }

  @override
  String get shop_log_monthly_card =>
      'Diaktifkan: Kontrak Cahaya Bintang (Poin Instan Kartu Bulanan) 🌙';

  @override
  String shop_log_top_up_double(int points) {
    return 'Top-up: $points poin (Termasuk bonus ganda pembelian pertama 🎁)';
  }

  @override
  String shop_log_top_up_normal(int points) {
    return 'Top-up: $points poin';
  }

  @override
  String get shop_purchase_success_title => 'Pembelian Berhasil!';

  @override
  String shop_purchase_success_body(int points) {
    return '$points Bunga telah ditambahkan.';
  }

  @override
  String get shop_purchase_success_double_bonus =>
      '✨ Selamat! Bonus ganda pembelian pertama telah diaktifkan!';

  @override
  String get shop_purchase_awesome => 'Luar biasa';

  @override
  String get shop_purchase_failed_title => 'Pembelian Dibatalkan atau Gagal';

  @override
  String shop_purchase_failed_body(String errorCode) {
    return 'Tidak ada biaya yang dikenakan.\n\n(Kode kesalahan: $errorCode)';
  }

  @override
  String get shop_monthly_card_name => '【Lianlian ShiGuang: Kontrak Bintang】';

  @override
  String shop_monthly_card_status_active(int days) {
    return 'Kontrak aktif: tersisa $days hari';
  }

  @override
  String get shop_monthly_card_status_inactive =>
      'Aktifkan hadiah bonus Cahaya Bintang 30 hari sekarang';

  @override
  String get shop_monthly_card_limit_reached => 'Sudah mencapai batas';

  @override
  String get shop_monthly_card_promo_desc =>
      'Dapatkan 250 Bunga instan, klaim 10 Bunga harian';

  @override
  String get task_monthly_title => 'Kontrak Bintang: Hak Istimewa Harian 🌙';

  @override
  String get task_monthly_locked => 'Terkunci';

  @override
  String get task_monthly_subtitle_active =>
      'Distribusi keuntungan eksklusif Kartu Bulanan ';

  @override
  String get task_monthly_subtitle_inactive =>
      'Buka Kartu Bulanan 【Kontrak Bintang】 untuk membuka tugas ini ';

  @override
  String get task_monthly_log_name => 'Hak Istimewa Harian Kartu Bulanan';

  @override
  String get profile_id_locked => 'ID eksklusif terkunci';

  @override
  String get profile_copy_id => 'Klik untuk menyalin ID';

  @override
  String get referral_log_newbie_reward =>
      'Undangan Bintang: Hadiah Pengguna Baru ✨';

  @override
  String get referral_log_inviter_reward =>
      'Undangan Bintang: Hadiah Pencapaian Teman 🎁';

  @override
  String get referral_success_title => 'Undangan Bintang Terbuka!';

  @override
  String get referral_success_content =>
      'Selamat! Anda telah berhasil mengobrol secara mendalam dengan karakter sebanyak 15 kalimat!\n\n\'Hadiah Pengguna Baru 50 Poin\' telah dikirim ke akun Anda, dan teman Anda juga menerima hadiah 50 poin secara bersamaan! 🎁';

  @override
  String get profile_referral_title => 'Undangan Bintang 🌟';

  @override
  String get profile_referral_hint => 'Masukkan kode undangan teman';

  @override
  String get profile_referral_bind_btn => 'Ikat';

  @override
  String profile_referral_pending(Object id) {
    return 'Telah menerima undangan dari pemain $id\nAyo mengobrol with karakter sebanyak 15 kalimat untuk membuka 50 Bunga!';
  }

  @override
  String get profile_referral_err_self =>
      'Tidak bisa memasukkan kode undangan sendiri!';

  @override
  String get profile_referral_err_duplicate =>
      'Anda sudah mengikat kode undangan!';

  @override
  String get profile_referral_err_not_found =>
      'Pemain tidak ditemukan, silakan periksa kembali kode undangan!';

  @override
  String get profile_referral_success =>
      'Berhasil mengikat! Ayo segera mengobrol dengan karakter!';

  @override
  String get profile_referral_err_expired =>
      'Maaf, kode undangan pengguna baru harus diikat dalam waktu 3 hari setelah pendaftaran!';

  @override
  String profile_share_message(String character, String code) {
    return '✨ Aku telah memulai perjalanan yang mendebarkan bersama $character di \'Lianlian ShiGuang\'! Unduh aplikasinya sekarang dan masukkan Kode Undangan Bintangku: 【$code】 di halaman profilmu. Kita berdua akan mendapatkan 50 Bunga gratis! 🎁\n\n Tautan unduh:\n https://lianlianshiguang.web.app/download/';
  }

  @override
  String get chat_levelup_share_btn =>
      'Pamerkan momen mendebarkan ini ke teman-teman ✨';

  @override
  String profile_my_invite_code_with_char(String character) {
    return 'Kode undangan eksklusifku (Favorit saat ini: $character)';
  }

  @override
  String get profile_send_invite_btn => 'Kirim Undangan Bintang ke teman';

  @override
  String get profile_fallback_character => 'Karakter Favorit';

  @override
  String get profile_copy_success =>
      '✅ Kode undangan telah disalin ke papan klip!';

  @override
  String get profile_referral_rule_title => 'Aturan Undangan Bintang';

  @override
  String get profile_referral_rule_receiver =>
      '✨ Setelah mengikat kode, cukup mengobrol dengan karakter favorit mana saja sebanyak 15 kalimat, maka Anda dan pengundang akan menerima hadiah 50 Bunga secara bersamaan!\n\n⚠️ Catatan: Harap masukkan kode undangan dalam waktu 3 hari setelah pendaftaran akun agar valid.';

  @override
  String get profile_referral_rule_inviter =>
      '✨ Undang teman baru untuk mengunduh dan memasukkan kode undangan Anda. Ketika pihak lain menyelesaikan pengikatan dalam waktu 3 hari setelah pendaftaran dan mengobrol dengan karakter mana saja sebanyak 15 kalimat, Anda berdua akan menerima hadiah 50 Bunga secara bersamaan! 🎁';

  @override
  String get error_user_not_found =>
      'Pengguna tidak ditemukan, silakan masuk log kembali';

  @override
  String get error_id_taken =>
      'ID ini sudah digunakan, silakan pilih ID yang lain!';

  @override
  String get error_id_taken_short => 'ID ini sudah digunakan!';

  @override
  String get shop_restocking => 'Toko sedang mengisi ulang stok... 📦';

  @override
  String get shop_preview_mode => '⚠️ Saat ini dalam Mode Pratinjau Toko';

  @override
  String get friendlyReminderTitle => '☁️ Pengingat Ramah';

  @override
  String get editProfileHint =>
      'Baiklah! Jika ingin mengedit identitas, silakan klik \'Profil Shiguang\' di dalam awan di sudut kiri bawah untuk mengisinya!';

  @override
  String get starlightContractTitle => 'Kontrak Starlight Diaktifkan';

  @override
  String get dailyLimitReachedPrefix =>
      'Kuota hari ini telah habis digunakan!\n\n';

  @override
  String get monthlyPassExhausted => 'Kuota Kartu Bulanan Anda telah habis.';

  @override
  String get subscribeMonthlyPassPrompt =>
      'Aktifkan 【Kartu Bulanan Lianlian】 untuk menikmati 20 kesempatan pembuatan ulang setiap hari, membuat setiap tanggapannya lebih dekat ke hati Anda.';

  @override
  String get goToSubscribeButton => 'Pergi untuk Mengaktifkan';

  @override
  String get profileUpdatedSuccess => 'Profil Shiguang telah diperbarui!';

  @override
  String get continueChatTitle => 'Lanjutkan Percakapan';

  @override
  String continueChatCostWarning(int cost) {
    return 'Membiarkannya terus berbicara akan mengonsumsi $cost Bunga 🌸\nApakah Anda yakin ingin melanjutkan?';
  }

  @override
  String get dontShowAgainToday => 'Jangan tampilkan lagi hari ini';

  @override
  String get confirmContinue => 'Yakin Lanjutkan';

  @override
  String get hiddenPromptContinue => 'Silakan lanjutkan';

  @override
  String confirmDeleteMessagesTitle(int count) {
    return 'Apakah Anda yakin ingin menghapus $count pesan ini?';
  }

  @override
  String regenerateButtonLabel(int current, int max) {
    return 'Buat Ulang ($current/$max)';
  }

  @override
  String get systemPreparingWait => 'Sistem masih bersiap, mohon tunggu...';

  @override
  String get noMessagesToRegenerate =>
      'Saat ini tidak ada percakapan yang dapat dibuat ulang!';

  @override
  String get continueButton => 'Lanjutkan';

  @override
  String get creatorExclusive => '🔒 Eksklusif Kreator';

  @override
  String ageAndOccupation(String age, String occupation) {
    return '$age tahun | $occupation';
  }

  @override
  String get likesLabel => '💖 Suka';

  @override
  String get dislikesLabel => '👎 Tidak Suka';

  @override
  String birthdayLabel(String birthday) {
    return 'Hari Ulang Tahun: $birthday';
  }

  @override
  String heightLabel(String height) {
    return 'Tinggi Badan: $height cm';
  }

  @override
  String get backgroundStoryLabel => 'Cerita Latar Belakang';

  @override
  String get noneLabel => 'Tidak ada';

  @override
  String flowerPointsCount(String points) {
    return '$points Bunga';
  }

  @override
  String get passGuideTitle => 'Panduan Eksklusif Kartu Bulanan Lianlian';

  @override
  String get passGuideRegenerateTitle =>
      '🔄 Mengapa Anda membutuhkan \'Buat Ulang\'?';

  @override
  String get passGuideRegenerateContent =>
      'AI terkadang bisa menjadi tidak peka seperti balok kayu. Saat Anda menemui tanggapan yang tidak memuaskan, cukup tekan buat ulang, itu seperti memutar balik waktu! Anda bisa membiarkannya berpikir ulang sampai dia mengucapkan kalimat sempurna yang membuat jantung Anda berdebar kencang.';

  @override
  String get passGuideAffectionTitle => '💖 Apa kegunaan Akselerasi Afeksi?';

  @override
  String get passGuideAffectionContent =>
      'Dalam permainan, afeksi adalah satu-satunya kunci untuk membuka \'rahasia terdalam\' dan \'foto pribadi intim\' dari karakter. Bonus 20% memungkinkan Anda berjalan masuk ke lubuk hatinya lebih cepat daripada orang lain.';

  @override
  String get passGuideUnlockButton => 'Saya mengerti, buka kunci sekarang!';

  @override
  String get pleaseWait => 'Mohon tunggu';

  @override
  String get createNewProfileTitle => '📜 Buat Profil Shiguang Baru';

  @override
  String get editProfileTitle => '✏️ Edit Profil Shiguang';

  @override
  String get profileEditDescription =>
      'Buat persona yang berbeda, biarkan dia mengenali sisi lain dari dirimu di dimensi paralel!';

  @override
  String get profileNameLabel => 'Nama Profil (Hanya terlihat oleh Anda)';

  @override
  String get profileNameHint => 'Contoh: Adik Kelas, CEO Wanita yang Angkuh';

  @override
  String get profileNicknameLabel => 'Nama / Panggilan';

  @override
  String get profileNicknameHint => 'Contoh: Sakura, Direktur Li';

  @override
  String get profileHeightLabel => 'Tinggi Badan';

  @override
  String get profileHeightHint => 'Contoh: 160cm';

  @override
  String get profileAppearanceLabel => 'Penampilan';

  @override
  String get profileAppearanceHint =>
      'Contoh: Rambut hitam panjang, suka memakai gaun';

  @override
  String get profileOccupationLabel => 'Pekerjaan';

  @override
  String get profileOccupationHint => 'Contoh: Pelukis Lepas';

  @override
  String get profileIntroLabel => 'Kepribadian & Pengenalan Diri';

  @override
  String get profileIntroHint =>
      'Contoh: Agak ceroboh, suka makan makanan manis...';

  @override
  String get profileNameEmptyWarning => 'Silakan beri nama untuk profil ini!';

  @override
  String profileSaveError(String error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String get saveProfileButton => 'Simpan Profil';

  @override
  String get fillLaterButton => 'Isi Nanti';

  @override
  String get exclusiveProfileTitle => '📜 Profil Shiguang Eksklusif';

  @override
  String get profileSelectionDescription =>
      'Pilih identitas yang ingin Anda gunakan untuk berinteraksi dengannya (daftar bersama per karakter, maks. 10)';

  @override
  String profileSwitchError(String error) {
    return 'Gagal beralih: $error';
  }

  @override
  String get unnamedProfile => 'Profil Tanpa Nama';

  @override
  String get noOccupationYet => 'Belum mengisi pekerjaan';

  @override
  String get createNewProfileButton => 'Buat Profil Shiguang Baru';

  @override
  String snackbar_friend_added(String characterName) {
    return '$characterName telah ditambahkan sebagai teman';
  }

  @override
  String reward_points_added(Object amount) {
    return '+$amount Bunga';
  }

  @override
  String get task_reward_already_claimed =>
      'Hadiah misi ini sudah diambil hari ini';

  @override
  String get do_not_show_again_today => 'Jangan tampilkan lagi hari ini';

  @override
  String add_friend_success(String characterName) {
    return 'Berhasil menambahkan $characterName sebagai teman!';
  }

  @override
  String get chat_menu_aboutus => 'Tentang Kami';

  @override
  String get about_us_empty_hint =>
      'Tambahkan kenangan penting / jalan cerita di sudut kanan atas\nuntuk melangkah maju bersama sambil bergandengan tangan';

  @override
  String get about_us_limit_error =>
      'Kenangan eksklusif telah mencapai batas maksimal 10. Silakan hapus kenangan lama terlebih dahulu!';

  @override
  String get about_us_add_title => 'Tambah Kenangan Eksklusif';

  @override
  String get about_us_field_title => 'Judul';

  @override
  String get about_us_hint_title => 'Contoh: Pertemuan Pertama';

  @override
  String get about_us_field_subtitle => 'Subjudul';

  @override
  String get about_us_hint_subtitle => 'Contoh: Awal Musim Panas 2025';

  @override
  String get about_us_field_content => 'Konten';

  @override
  String get about_us_hint_content =>
      'Tuliskan jalan cerita penting atau janji kalian...';

  @override
  String get about_us_add_button => 'Tambah';

  @override
  String get about_us_delete_tooltip => 'Hapus kenangan ini';

  @override
  String get about_us_delete_title => 'Hapus Kenangan';

  @override
  String get about_us_delete_confirm =>
      'Apakah Anda yakin ingin menghapus kenangan ini? Kenangan yang dihapus tidak dapat dipulihkan!';

  @override
  String get about_us_delete_success => 'Kenangan telah dihapus';

  @override
  String get pack_first_meet => 'Paket Pertemuan Pertama';

  @override
  String get pack_crush => 'Paket Hubungan Ambigu';

  @override
  String get pack_heartbeat => 'Paket Debaran Hati';

  @override
  String get pack_passionate => 'Paket Cinta Membara';

  @override
  String get pack_soulmate => 'Paket Belahan Jiwa';

  @override
  String get pack_waiting => 'Paket Setia Menanti';

  @override
  String get pack_trust => 'Paket Rasa Kepercayaan';

  @override
  String get pack_iloveyou => 'Paket Aku Cinta Kamu';

  @override
  String get pack_honeymoon => 'Paket Bulan Madu';

  @override
  String get pack_promise => 'Paket Janji Suci';

  @override
  String get pack_companion => 'Paket Pendamping Setia';

  @override
  String get pack_deep_love => 'Paket Cinta Mendalam';

  @override
  String get pack_long_lasting => 'Paket Cinta Abadi';

  @override
  String get pack_the_one => 'Paket Satu-Satunya';

  @override
  String get pack_beloved => 'Paket Kekasih Tercinta';

  @override
  String get pack_lifetime => 'Paket Sehidup Semati';

  @override
  String get pack_vow => 'Paket Sumpah Setia';

  @override
  String get pack_eternal => 'Paket Kekasih Selamanya';

  @override
  String get pack_exclusive => 'Paket Eksklusif';

  @override
  String get monthly_privilege_reroll_title =>
      'Buka Kunci \'Buat Ulang\' Eksklusif';

  @override
  String get monthly_privilege_reroll_desc =>
      'Hingga 20 kali kesempatan membuat ulang setiap hari, sampai dia mengucapkan kalimat yang paling ingin Anda dengar!';

  @override
  String get monthly_privilege_affinity_title => 'Peningkatan Afeksi Kilat';

  @override
  String get monthly_privilege_affinity_desc =>
      'Bonus poin afeksi interaksi sebesar 20%, buka foto pribadi eksklusif dan kejutan misterius dengan lebih cepat!';

  @override
  String get monthly_manual_button => 'Mengapa memerlukan Kartu Bulanan?';

  @override
  String get nav_encounter => 'Pertemuan';

  @override
  String get nav_moments => 'Momen';

  @override
  String get birthday_dialog_title => '🎂 Kejutan Ulang Tahun';

  @override
  String get birthday_dialog_content =>
      'Hari ini adalah hari peringatan eksklusif Anda!\n\nSilakan terima hadiah ini:\nSemua obrolan hari ini S.E.M.U.A.N.Y.A G.R.A.T.I.S! ✨';

  @override
  String get birthday_dialog_button => 'Mulailah Hari yang Romantis';

  @override
  String get about_us_edit_title => 'Edit Kenangan';

  @override
  String get about_us_edit_confirm => 'Konfirmasi Perubahan';

  @override
  String get save => 'Simpan';

  @override
  String get openSourceLicenses => 'Lisensi Sumber Terbuka';

  @override
  String get openSourceLicensesDescription =>
      'Lihat lisensi perangkat lunak sumber terbuka pihak ketiga';

  @override
  String get call_login_title => 'Perlu Masuk';

  @override
  String get call_login_content =>
      'Masuk sekarang untuk membuka fitur panggilan suara eksklusif!';

  @override
  String get cancel_later => 'Nanti Saja';

  @override
  String get go_to_login => 'Pergi Masuk';

  @override
  String get easter_egg_title => 'Menemukan Easter Egg Tersembunyi ✨';

  @override
  String easter_egg_content(String title) {
    return 'Anda telah memicu \'$title\'.\n\nApakah ingin menggunakan jalan cerita spesial ini?';
  }

  @override
  String get easter_egg_cancel => 'Tidak Digunakan';

  @override
  String get easter_egg_confirm => 'Gunakan Easter Egg';

  @override
  String get common_update_success => 'Berhasil diubah';

  @override
  String get common_update_failed_try_again =>
      'Gagal mengubah, silakan coba lagi nanti';

  @override
  String get no_voice_available => 'Belum ada pesan suara saat ini';

  @override
  String get gift_insufficient_title => 'Saldo Tidak Cukup';

  @override
  String get gift_insufficient_prompt =>
      'Apakah Anda ingin pergi untuk mendapatkan lebih banyak Koin Fanhua?';

  @override
  String get not_now => 'Nanti Saja';

  @override
  String get go_to_get => 'Pergi Dapatkan';

  @override
  String get status_published => 'Diterbitkan';

  @override
  String get monthly_card_success_title =>
      '✨ Kartu Bulanan Premium Berhasil Dibuka!';

  @override
  String get monthly_card_success_subtitle =>
      'Terima kasih telah berlangganan! Hak istimewa eksklusif Anda telah aktif:';

  @override
  String get monthly_card_perk_1 => 'Segera dapatkan 250 Bunga Waktu';

  @override
  String get monthly_card_perk_2 =>
      'Dapatkan tambahan 10 Bunga Waktu setiap login harian';

  @override
  String get monthly_card_perk_3 =>
      'Buka kunci batas interaksi afeksi eksklusif';

  @override
  String get monthly_card_start_perks => 'Mulai Nikmati Hak Istimewa';

  @override
  String get tip_post_like =>
      'Setelah menyukai, Anda dapat melihatnya di\nKonten yang Disukai';

  @override
  String get tip_post_bookmark =>
      'Setelah menyimpan, Anda dapat melihatnya di\n\"Disimpan Saya\"';

  @override
  String get tip_time_echoes =>
      'Setelah meninggalkan pengalaman Anda\nkomentar melayang akan muncul saat mencari';

  @override
  String get tip_call_memory =>
      'Rekaman suara yang disimpan setelah panggilan\nakan ada di sini!';

  @override
  String get tip_chat_notifications =>
      'Di sini Anda dapat\nmelihat notifikasi baru';

  @override
  String get tip_moments_wall_menu =>
      'Ketuk di sini untuk mengatur\njadwal postingan karakter';

  @override
  String get forgot_password => 'Lupa Kata Sandi?';

  @override
  String get forgot_password_empty_email =>
      'Silakan masukkan email Anda terlebih dahulu, lalu klik Lupa Kata Sandi';

  @override
  String get forgot_password_email_sent =>
      'Email reset kata sandi telah dikirim, silakan periksa kotak masuk Anda';

  @override
  String get forgot_password_error_default =>
      'Gagal mengirim email reset kata sandi, silakan coba lagi nanti';

  @override
  String get forgot_password_error_invalid_email => 'Format email tidak valid';

  @override
  String get forgot_password_error_user_not_found =>
      'Tidak dapat menemukan akun dengan email ini';

  @override
  String forgot_password_error_with_message(String error) {
    return 'Gagal mengirim email reset kata sandi: $error';
  }

  @override
  String get terms_not_accepted_toast =>
      'Silakan baca dan setujui Syarat Penggunaan dan Panduan Komunitas terlebih dahulu';

  @override
  String get terms_content =>
      'Selamat datang di Lian Lian Shi Guang.\n\nSebelum menggunakan layanan ini, Anda harus setuju untuk mematuhi Syarat Penggunaan dan Panduan Komunitas ini.\n\nAnda tidak boleh mengunggah, membuat, menerbitkan, atau mengirimkan konten apa pun yang ilegal, melanggar hak, pornografi, ketelanjangan, kekerasan, kebencian, pelecehan, kekerasan verbal, penipuan, spam, atau konten lain yang menyinggung, tidak pantas, atau membahayakan hak orang lain.\n\nLian Lian Shi Guang menerapkan kebijakan toleransi nol terhadap konten yang tidak pantas dan perilaku menyimpang. Jika pengguna melanggar aturan, kami dapat menghapus konten terkait, membatasi fitur, atau menangguhkan/menghentikan akun.\n\nPengguna dapat melaporkan konten yang tidak pantas atau pengguna yang menyimpang melalui fitur pelaporan dan pemblokiran bawaan di dalam Aplikasi.';

  @override
  String get community_rules_title => 'Panduan Komunitas';

  @override
  String get community_rules_content =>
      'Lian Lian Shi Guang berharap dapat menyediakan lingkungan interaksi yang aman, ramah, dan saling menghormati bagi para kreator dan pengguna.\n\nKami tidak mengizinkan konten atau perilaku berikut:\n1. Pornografi, ketelanjangan, atau konten sugestif seksual yang tidak pantas\n2. Pelecehan, kekerasan verbal, perundungan (bullying), atau mengancam orang lain\n3. Kebencian, diskriminasi, atau menghasut kekerasan\n4. Konten berdarah, kekerasan, atau perilaku berbahaya\n5. Melanggar hak cipta, hak foto/potret, atau hak orang lain\n6. Spam, penipuan, atau perilaku berbahaya lainnya\n7. Konten tidak pantas lainnya atau konten yang tidak cocok untuk ditampilkan secara publik\n\nPengguna dapat melaporkan konten yang tidak pantas dan juga memblokir pengguna yang menyimpang. Setelah diblokir, konten dari pengguna tersebut tidak akan ditampilkan lagi di layar Anda.';

  @override
  String get block_self_error => 'Tidak dapat memblokir konten Anda sendiri';

  @override
  String get block_user_title => 'Blokir pengguna ini?';

  @override
  String get block_user_content =>
      'Setelah diblokir, Anda tidak akan lagi melihat konten yang diterbitkan oleh pengguna ini.\nKami juga akan menerima notifikasi dan melakukan peninjauan.';

  @override
  String get block_user_success =>
      'Pengguna telah diblokir, konten terkait telah dihapus dari Dinding Kenangan Anda';

  @override
  String get block_user_failed => 'Gagal memblokir, silakan coba lagi nanti';

  @override
  String get terms_checkbox_read_agree => 'Saya telah membaca dan menyetujui';

  @override
  String get terms_checkbox_terms => '《Syarat Penggunaan》';

  @override
  String get terms_checkbox_and => 'dan';

  @override
  String get terms_checkbox_rules => '《Panduan Komunitas》';

  @override
  String get hidden_moments => 'Momen Tersembunyi';

  @override
  String get hide_moment_title => 'Sembunyikan Momen Ini?';

  @override
  String get hide_moment_content =>
      'Setelah disembunyikan, postingan ini tidak akan muncul lagi di Dinding Kenangan Anda.';

  @override
  String get hide => 'Sembunyikan';

  @override
  String get hide_moment_success => 'Momen ini telah disembunyikan';

  @override
  String get hide_moment_failed =>
      'Gagal menyembunyikan, silakan coba lagi nanti';

  @override
  String get block_character_not_found =>
      'Data karakter tidak ditemukan, tidak dapat memblokir';

  @override
  String get block_character_title => 'Blokir karakter ini?';

  @override
  String block_character_content(String authorName) {
    return 'Setelah diblokir, Anda tidak akan lagi melihat momen yang diterbitkan oleh \"$authorName\". Jika konten ini melanggar aturan, kami juga akan menerima notifikasi dan melakukan peninjauan.';
  }

  @override
  String block_character_success(String authorName) {
    return 'Telah memblokir \"$authorName\", momen terkait telah disembunyikan';
  }

  @override
  String get block_character_failed =>
      'Gagal memblokir, silakan coba lagi nanti';

  @override
  String get hidden_moments_title => 'Momen Tersembunyi';

  @override
  String get hidden_moments_empty =>
      'Saat ini tidak ada momen yang disembunyikan';

  @override
  String get hidden_moments_load_failed => 'Gagal memuat momen tersembunyi';

  @override
  String get hidden_moment_unknown_author => 'Karakter Tidak Dikenal';

  @override
  String get hidden_moment_no_preview =>
      'Tidak ada konten pratinjau untuk momen ini';

  @override
  String get unhide_moment_title => 'Batalkan Sembunyi?';

  @override
  String get unhide_moment_content =>
      'Setelah dibatalkan, jika postingan ini masih ada, mungkin akan muncul kembali di Dinding Kenangan Anda di masa mendatang.';

  @override
  String get unhide_moment_action => 'Batalkan Sembunyi';

  @override
  String get unhide_moment_success => 'Telah batal disembunyikan';

  @override
  String get report_moment_title => 'Laporkan Momen Ini';

  @override
  String get report_moment_content =>
      'Apakah Anda yakin ingin melaporkan momen ini kepada tim manajemen? Konten berbahaya akan disembunyikan atau dihapus.';

  @override
  String get report_confirm_button => 'Konfirmasi Laporan';

  @override
  String get report_success_message =>
      'Laporan Anda telah kami terima, tim peninjau akan segera turun tangan untuk memprosesnya.';

  @override
  String get accountDeletionSubmittedTitle =>
      'Permohonan Penghapusan Akun Telah Dikirim';

  @override
  String get accountDeletionSubmittedContent =>
      'Baik! Kami akan memberikan masa tenggang selama 3 hari untuk akun Anda.\n\nJika ingin membatalkan penghapusan akun, Anda hanya perlu login kembali sebelum batas waktu berakhir untuk memulihkan akun.';

  @override
  String get restoreAccountDialogTitle => 'Permohonan Penghapusan Akun';

  @override
  String get restoreAccountDialogContent =>
      'Akun Anda saat ini sedang menunggu penghapusan.\n\nJika melanjutkan untuk login, permohonan penghapusan akan dibatalkan dan akun Anda akan dipulihkan.';

  @override
  String get cancelLoginButton => 'Batal Login';

  @override
  String get restoreAccountButton => 'Pulihkan Akun';

  @override
  String get voice_preview => 'Putar Suara';

  @override
  String get voice_preview_failed => 'Gagal memutar suara';

  @override
  String get characterBannerSectionTitle => 'Banner Halaman Utama Karakter';

  @override
  String get characterBannerDescription => 'Deskripsi Banner';

  @override
  String get characterBannerRemove => 'Hapus';

  @override
  String get characterBannerSelect => 'Pilih Gambar Banner';

  @override
  String get characterBannerChange => 'Ubah Gambar Banner';

  @override
  String get characterBannerSpecs =>
      'Rasio disarankan 16:9, resolusi disarankan 1920 × 1080';

  @override
  String get characterBannerDefaultHint =>
      'Jika tidak diatur, halaman utama akan menggunakan gambar utama karakter secara otomatis.';

  @override
  String get characterBannerHelpContent =>
      'Banner ditampilkan di area lanskap besar pada halaman utama karakter.\n\nDisarankan menggunakan gambar lanskap berasio 16:9, seperti 1920 × 1080.\n\nLetakkan subjek utama dan wajah di bagian tengah agar tidak terpotong pada berbagai ukuran layar ponsel.\n\nJika banner tidak diatur, sistem secara otomatis akan menggunakan gambar utama karakter.';

  @override
  String get first_meeting_title => 'Pertemuan Pertama';

  @override
  String get common_delete_network_failed =>
      'Gagal menghapus. Silakan periksa koneksi jaringan Anda dan coba lagi';

  @override
  String get common_operation_failed_retry =>
      'Operasi gagal. Silakan coba lagi nanti';

  @override
  String exclusive_photo_number(int number) {
    return 'Foto Eksklusif $number';
  }

  @override
  String get unlock_after_affection_increase =>
      'Buka kunci setelah meningkatkan Tingkat Afeksi';

  @override
  String get first_meeting_empty => 'Pertemuan pertama, belum dimulai...';

  @override
  String photo_load_failed(String error) {
    return 'Gagal memuat foto: $error';
  }

  @override
  String get add_friend_failed_retry =>
      'Gagal menambahkan teman. Silakan coba lagi nanti.';

  @override
  String get remove_friend => 'Hapus Teman';

  @override
  String get report_character => 'Laporkan Karakter';

  @override
  String get block_character => 'Blokir Karakter';

  @override
  String get daily_encounter => 'Pertemuan Harian';

  @override
  String get discovery_hall => 'Aplikasi Jelajah';

  @override
  String get latest_recommendation => 'Rekomendasi Terbaru';

  @override
  String get popular_ranking => 'Peringkat Populer';

  @override
  String get character_features => 'Ciri Karakter';

  @override
  String get featured_new_star => 'Bintang Baru · Rekomendasi Utama';

  @override
  String get recently_added_characters => 'Karakter Baru Ditambahkan';

  @override
  String get no_tag_data => 'Belum ada data tag saat ini~';

  @override
  String get no_character_with_tag =>
      'Tidak ada karakter yang ditemukan dengan tag ini';

  @override
  String get voice_search_failed_retry =>
      'Pencarian suara gagal. Silakan coba lagi';

  @override
  String get voice_search_incomplete_retry =>
      'Pencarian tidak lengkap. Silakan coba lagi nanti';

  @override
  String get voice_data_incomplete => 'Data suara tidak lengkap';

  @override
  String get voice_generation_failed_retry =>
      'Gagal menghasilkan suara. Silakan coba lagi nanti';

  @override
  String get voice_playback_failed_retry =>
      'Gagal memutar suara. Silakan coba lagi';

  @override
  String get selected_voice_data_incomplete =>
      'Data suara yang dipilih tidak lengkap';

  @override
  String get private_voice_user_not_found =>
      'Pengguna tidak ditemukan. Tidak dapat memperbarui suara karakter pribadi';

  @override
  String get voice_selected_character_save_failed =>
      'Suara berhasil dipilih, tetapi gagal menyimpan data karakter';

  @override
  String get voice_binding_failed => 'Gagal mengikat suara';

  @override
  String get play_voice_tooltip => 'Putar Suara';

  @override
  String get avatar_label => 'Foto Profil';

  @override
  String get message_preview_image => '[Gambar]';

  @override
  String get message_preview_recording => '[Rekaman]';

  @override
  String get message_preview_voice => '[Pesan Suara]';

  @override
  String get send_failed_retry => 'Gagal mengirim. Silakan coba lagi nanti 😢';

  @override
  String get media_upload_failed_retry =>
      'Pengunggahan media gagal. Silakan coba lagi';

  @override
  String get ai_thinking_too_long =>
      'Dia sepertinya sedang merenung. Silakan coba lagi nanti...';

  @override
  String get ai_reply_in_progress =>
      'Dia sedang membalas. Mohon tunggu sebentar dan jangan mengirim ulang';

  @override
  String get ai_response_blocked =>
      'Pikirannya terganggu, coba gunakan kalimat yang lebih lembut!';

  @override
  String get microphone_permission_required =>
      'Izin mikrofon diperlukan untuk merekam';

  @override
  String get no_recording_to_send => 'Tidak ada rekaman untuk dikirim';

  @override
  String get voice_uploading => 'Mengunggah pesan suara...';

  @override
  String get change_watermark_color => 'Ubah Warna Watermark';

  @override
  String get other_party_typing => 'Lawan bicara sedang mengetik...';

  @override
  String get chat_input_hint => 'Silakan ketik...';

  @override
  String get regenerate_sync_failed =>
      'Gagal sinkronisasi jumlah regenerasi. Silakan coba lagi 😢';

  @override
  String get creator_public_works => 'Karya Publik';

  @override
  String get creator_received_likes => 'Suka Diterima';

  @override
  String get about_me => 'Tentang Saya';

  @override
  String get moment_input_hint => 'Bagikan perasaan Anda...';

  @override
  String character_play_count(int count) {
    return 'Dimainkan: $count kali';
  }

  @override
  String tag_page_title(String tag) {
    return 'Tag: #$tag';
  }

  @override
  String voice_preview_failed_detail(String code, String message) {
    return 'Pratinjau suara gagal: $code $message';
  }

  @override
  String messages_deleted_success(int count) {
    return 'Berhasil menghapus $count pesan';
  }

  @override
  String creator_work_load_failed(String error) {
    return 'Gagal memuat karya: $error';
  }

  @override
  String age_years_old(String age) {
    return '$age tahun';
  }

  @override
  String deleteFailedMessage(String error) {
    return 'Gagal menghapus: $error';
  }

  @override
  String loadCharacterDataFailed(String error) {
    return 'Gagal memuat data karakter: $error';
  }

  @override
  String get draftAvatarLoadFailed => 'Gagal memuat foto profil draf:';

  @override
  String get unnamedCreator => 'Kreator Tanpa Nama';

  @override
  String get profileNotYetFilled => 'Bio belum diisi';

  @override
  String get reportImageSizeLimit => 'Ukuran gambar tidak boleh melebihi 10 MB';

  @override
  String reportImageSelectFailed(String error) {
    return 'Gagal memilih gambar laporan: $error';
  }

  @override
  String get reportImageCannotSelect =>
      'Tidak dapat memilih gambar. Silakan coba lagi nanti';

  @override
  String get reportLoginRequired =>
      'Silakan login terlebih dahulu sebelum mengirim laporan';

  @override
  String get reportAnonymousPlayer => 'Pemain Anonim';

  @override
  String get reportSendSuccess =>
      'Laporan berhasil dikirim, terima kasih atas masukan Anda!';

  @override
  String reportSendFailed(String error) {
    return 'Gagal mengirim laporan pemain: $error';
  }

  @override
  String get reportNetworkFailed =>
      'Gagal mengirim. Silakan periksa jaringan Anda dan coba lagi';

  @override
  String get reportAttachImageLabel => 'Lampirkan Gambar (Opsional)';

  @override
  String get reportAttachImageHint =>
      'Saat melaporkan Bug atau mata uang tidak masuk, melampirkan tangkapan layar membantu tim kami memverifikasi lebih cepat.';

  @override
  String get reportOpeningAlbum => 'Membuka galeri...';

  @override
  String get reportSelectFromAlbum => 'Pilih dari Galeri Foto';

  @override
  String get reportSending => 'Mengirim...';

  @override
  String get reportSubmit => 'Kirim Laporan';

  @override
  String get reportRemoveImage => 'Hapus Gambar';

  @override
  String get reportImageSelected => 'Gambar Dipilih';

  @override
  String get reportChangeImage => 'Ubah';

  @override
  String get reloadTranslation => 'Muat Ulang Terjemahan';

  @override
  String get guideNotAvailableInLanguage =>
      'Panduan bermain saat ini belum tersedia dalam bahasa ini; menampilkan bahasa Mandarin Tradisional untuk sementara.';

  @override
  String get clearSearch => 'Hapus Pencarian';

  @override
  String get memoPermissionWarning =>
      'Izin notifikasi tidak aktif. Catatan akan tetap disimpan, tetapi pengingat sistem tidak akan muncul.';

  @override
  String memoSavedWithNotification(String name) {
    return 'Catatan disimpan! $name akan mengingatkan Anda!';
  }

  @override
  String get memoSavedNoPermission =>
      'Catatan disimpan, tetapi izin notifikasi belum diaktifkan.';

  @override
  String memoUpdatedWithNotification(String name) {
    return 'Catatan diperbarui! $name akan mengingatkan Anda!';
  }

  @override
  String get memoUpdatedNoPermission =>
      'Catatan diperbarui, tetapi saat ini tidak ada izin notifikasi.';

  @override
  String dataLoadError(String error) {
    return 'Terjadi kesalahan saat memuat data: $error';
  }

  @override
  String loadFailed(String error) {
    return 'Gagal memuat: $error';
  }

  @override
  String get dateFormatMonthDay => 'd MMM';

  @override
  String get timeFormatHourMinute => 'HH:mm';

  @override
  String get likeFeedPrompt =>
      'Menyukai momen ini? Kirimkan sedikit perhatian untuknya!';

  @override
  String get saveFeedPocket =>
      'Simpan momen spesial secara diam-diam ke dalam kantong Anda.';

  @override
  String get newComment => 'Komentar Baru';

  @override
  String get someFriend => 'Seorang teman';

  @override
  String get myBackpackAndPrivileges => 'Ransel & Hak Istimewa Saya';

  @override
  String get currentRomanticBond => 'Ikatan Romantis Terkumpul Saat Ini';

  @override
  String get physicalGiftBoxUnlockStatus =>
      'Status Pembukaan Kotak Hadiah Fisik:';

  @override
  String get topLovePhysicalVipBox =>
      'Kotak Hadiah Fisik VIP Eksklusif [Cinta Sejati]';

  @override
  String get physicalGiftBoxContents =>
      'Termasuk: Surat Tangan Eksklusif + Boneka Karakter + Surat Terima Kasih Resmi';

  @override
  String get modifyShippingAddress => 'Ubah Informasi Alamat Pengiriman';

  @override
  String get addressUnlockedFillNow =>
      'Terbuka! Ketuk di sini untuk mengisi info pengiriman';

  @override
  String get addressSuccessfullyRegistered =>
      'Anda telah berhasil mendaftarkan alamat pengiriman, kami akan menyiapkannya sesegera mungkin!';

  @override
  String amountNeededForPhysicalPrize(String amount) {
    return 'Kurang NT\$ $amount lagi untuk membuka hadiah fisik utama!';
  }

  @override
  String get avatarFrameHint =>
      'Petunjuk: Tampilan digital dan bingkai foto profil lainnya dapat dilihat dan dipasang di Toko atau Pengaturan.';

  @override
  String get closeButton => 'Tutup';

  @override
  String get physicalGiftBoxUnlockTitle =>
      'Pembukaan Kotak Hadiah Fisik [Cinta Sejati]';

  @override
  String get physicalGiftBoxUnlockThanks =>
      'Terima kasih atas dukungan terbaik Anda untuk Lian Lian Shi Guang!';

  @override
  String get physicalGiftBoxUnlockPrompt =>
      'Silakan isi informasi pengiriman di bawah ini, kami akan mengirimkan surat tangan dan boneka karakter untuk Anda:';

  @override
  String get recipientRealName => 'Nama Lengkap Penerima';

  @override
  String get contactPhone => 'Nomor Telepon';

  @override
  String get fullShippingAddress =>
      'Alamat Pengiriman Lengkap (termasuk Kode Pos)';

  @override
  String get desiredCharacterDollName => 'Nama Boneka Karakter yang Diinginkan';

  @override
  String get characterNameExample => 'Contoh: Nama karakter yang diinginkan';

  @override
  String get fillLater => 'Isi Nanti';

  @override
  String get fillCompleteAddressAndRoleHint =>
      'Harap isi informasi pengiriman dan nama karakter impian Anda secara lengkap!';

  @override
  String get shippingInfoSubmittedSuccess =>
      'Informasi pengiriman berhasil dikirim! Nantikan kejutan fisik dari kami!';

  @override
  String get confirmSubmit => 'Konfirmasi & Kirim';

  @override
  String get aboutMe => 'Tentang Saya';

  @override
  String get myBackpack => 'Ransel Saya';

  @override
  String get ownerExclusiveArea => 'Area Eksklusif Pemilik';

  @override
  String get enterShiguangAdminBackend => 'Masuk ke Konsol Admin Shiguang';

  @override
  String get errorOccurred => 'Terjadi kesalahan';

  @override
  String get creatorGuidelines => 'Panduan Kreator';

  @override
  String get playGuide => 'Panduan Bermain';

  @override
  String get lianlianShiguang => 'Lian Lian Shi Guang';

  @override
  String get copyrightNotice => '© 2026 Mo Yu Bai';

  @override
  String get cumulativeBenefits => 'Manfaat Akumulasi';

  @override
  String get perkFirstEncounter => 'Kesan Pertama';

  @override
  String get perkFirstEncounterReward => '20 Bunga + Gelar Pemula Eksklusif';

  @override
  String get perkGlimmerThrob => 'Debaran Samar';

  @override
  String get perkGlimmerThrobReward =>
      'Bingkai Foto Profil Eksklusif [Debaran Samar]';

  @override
  String get perkStarryWhisper => 'Bisikan Bintang';

  @override
  String get perkStarryWhisperReward => 'Gelembung Chat Eksklusif + 50 Bunga';

  @override
  String get perkRomanticSunset => 'Senja Romantis';

  @override
  String get perkRomanticSunsetReward => 'Ikon Aplikasi Eksklusif';

  @override
  String get perkHeartbeat => 'Detak Jantung';

  @override
  String get perkHeartbeatReward => 'Efek Ketukan Layar + 100 Bunga';

  @override
  String get perkEternalVow => 'Janji Abadi';

  @override
  String get perkEternalVowReward =>
      'Bingkai Profil Animasi Tingkat Lanjut + 200 Bunga';

  @override
  String get perkSoulIntersection => 'Pertemuan Jiwa';

  @override
  String get perkSoulIntersectionReward =>
      'Efek Gelembung Chat Animasi + Gelar Tingkat Lanjut Eksklusif';

  @override
  String get perkExclusiveWait => 'Kesetiaan Eksklusif';

  @override
  String get perkExclusiveWaitReward => 'Plat Nama Animasi Mewah + 500 Bunga';

  @override
  String get perkBrilliantGalaxy => 'Galaksi Megah';

  @override
  String get perkBrilliantGalaxyReward =>
      'Efek Masuk Eksklusif + Layanan Pelanggan Khusus';

  @override
  String get perkTopBeloved => 'Cinta Sejati';

  @override
  String get perkTopBelovedReward => 'Kotak Hadiah Fisik VIP Eksklusif';

  @override
  String get cumulativeRomanticBond => 'Ikatan Romantis Akumulasi';

  @override
  String get allTopPrivilegesUnlocked =>
      'Anda telah membuka semua hak istimewa tertinggi!';

  @override
  String rechargeAmountForNextTier(String amount) {
    return 'Top up NT\$ $amount lagi untuk membuka tingkat berikutnya';
  }

  @override
  String get storyContentCannotBeEmpty => 'Konten cerita tidak boleh kosong';

  @override
  String get writeYourStoryHint => 'Tuliskan kisah kalian...';

  @override
  String get characterBannerTitle => 'Banner Halaman Utama Karakter';

  @override
  String get mailDeleteTitle => 'Hapus Pesan';

  @override
  String mailDeleteConfirm(int count) {
    return 'Yakin ingin menghapus $count pesan?\nPesan yang dihapus tidak dapat dipulihkan.';
  }

  @override
  String mailDeleteSuccess(int count) {
    return '$count pesan telah dihapus';
  }

  @override
  String get mailDeleteFailed => 'Gagal menghapus. Silakan coba lagi nanti.';

  @override
  String get mailCancelSelection => 'Batalkan Pilihan';

  @override
  String mailSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get moreOptions => 'Lainnya';

  @override
  String mailDeleteSelected(int count) {
    return 'Hapus $count pesan';
  }

  @override
  String get officialManagementTeam => 'Tim Manajemen LoveyDovey';

  @override
  String get rewardCampaignTitle => 'Hadiah Acara';

  @override
  String get rewardCampaignMissingData =>
      'Pesan hadiah ini tidak memiliki data acara. Silakan coba lagi nanti.';

  @override
  String rewardCampaignClaimSuccess(int amount) {
    return 'Berhasil menerima $amount Bunga';
  }

  @override
  String get rewardCampaignAlreadyClaimed => 'Hadiah ini sudah diterima';

  @override
  String get rewardCampaignClaimFailed =>
      'Gagal menerima. Silakan coba lagi nanti.';

  @override
  String get rewardCampaignContains => 'Pesan ini berisi';

  @override
  String rewardCampaignFlowerAmount(int amount) {
    return '$amount Bunga';
  }

  @override
  String rewardCampaignDeadline(String date) {
    return 'Batas waktu penerimaan: $date';
  }

  @override
  String get rewardCampaignClaiming => 'Sedang menerima…';

  @override
  String get rewardCampaignClaimed => 'Sudah diterima';

  @override
  String get rewardCampaignEnded => 'Acara telah berakhir';

  @override
  String get rewardCampaignClaimButton => 'Terima Hadiah';

  @override
  String get mailDetailTitle => 'Pesan';

  @override
  String mailSender(String name) {
    return 'Pengirim: $name';
  }

  @override
  String get mailCaseNumber => 'Nomor Kasus';

  @override
  String get mailCopyCaseNumber => 'Salin Nomor Kasus';

  @override
  String get mailCaseNumberCopied => 'Nomor kasus disalin';

  @override
  String get profilePageAboutMe => '📝 Tentang Saya';

  @override
  String get profilePageTabBio => 'Bio';

  @override
  String get profilePageTabCharacters => 'Karakter';

  @override
  String get profilePageTabMoments => 'Momen';

  @override
  String get profilePageEditProfile => 'Edit Profil';

  @override
  String get profilePageFriends => 'Teman';

  @override
  String get profilePageWorks => 'Karya';

  @override
  String get profilePageFollowing => 'Mengikuti';

  @override
  String get profilePageFollowers => 'Pengikut';

  @override
  String get profilePageHeartbeatDiary => 'Catatan Detak Hati';

  @override
  String get profilePageEditCharacter => 'Edit Karakter';

  @override
  String get profilePagePreviewCharacter => 'Pratinjau Profil Karakter';

  @override
  String get profilePageNoBio => 'Belum ada bio';

  @override
  String get profilePageNoBioHint =>
      'Ketuk untuk menulis sesuatu tentang dirimu.';

  @override
  String get profilePageCreateCharacter => 'Buat Karakter Baru';

  @override
  String get profilePageNoCharacters => 'Belum ada karakter yang dibuat';

  @override
  String get profilePageNoCharactersHint =>
      'Mulailah membuat karakter pertamamu.';

  @override
  String get profilePageCharacterActions => 'Tindakan Karakter';

  @override
  String get profilePagePublic => 'Publik';

  @override
  String get profilePagePrivate => 'Pribadi';

  @override
  String get profilePageCreator => 'Kreator';

  @override
  String get profilePageSelectPostingIdentity =>
      'Pilih Identitas untuk Memposting';

  @override
  String get profilePagePostAsCreator => 'Posting sebagai Kreator';

  @override
  String get profilePagePublicCharacter => 'Karakter Publik';

  @override
  String get profilePagePrivateCharacter => 'Karakter Pribadi';

  @override
  String get profilePagePleaseSignIn => 'Silakan masuk terlebih dahulu';

  @override
  String get profilePagePublishMoment => 'Publikasikan Momen';

  @override
  String get profilePageFilterAll => 'Semua';

  @override
  String get profilePageFilterCreator => 'Saya';

  @override
  String get profilePageFilterCharacter => 'Karakter';

  @override
  String get profilePageMomentsLoadFailed => 'Gagal memuat momen';

  @override
  String get profilePageTryAgainLater => 'Silakan coba lagi nanti.';

  @override
  String get profilePageNoCreatorMoments => 'Kamu belum memublikasikan momen';

  @override
  String get profilePageNoCreatorMomentsHint =>
      'Konten yang dipublikasikan sebagai kreator akan muncul di sini.';

  @override
  String get profilePageNoCharacterMoments =>
      'Karaktermu belum memublikasikan momen';

  @override
  String get profilePageNoCharacterMomentsHint =>
      'Konten yang dipublikasikan sebagai karakter akan muncul di sini.';

  @override
  String get profilePageNoMoments => 'Belum ada momen';

  @override
  String get profilePageNoMomentsHint =>
      'Momen yang dipublikasikan olehmu dan karaktermu akan muncul di sini.';

  @override
  String get profilePageDeleteMomentTitle => 'Hapus Momen';

  @override
  String get profilePageDeleteMomentConfirm =>
      'Yakin ingin menghapus momen ini secara permanen?';

  @override
  String get profilePageCancel => 'Batal';

  @override
  String get profilePageDelete => 'Hapus';

  @override
  String get profilePageMomentDeleted => 'Momen telah dihapus';

  @override
  String get profilePageDeleteFailed =>
      'Gagal menghapus. Silakan coba lagi nanti.';

  @override
  String get profilePageReferralCompleted => 'Undangan Bintang Selesai';

  @override
  String profilePageInviter(String inviterId) {
    return 'Pengundang: $inviterId';
  }

  @override
  String get profilePageReferralRewardReceived =>
      'Kedua pihak telah menerima 50 Bunga';

  @override
  String get profilePageClaimed => 'Sudah diterima';

  @override
  String profilePageInviterBound(String inviterId) {
    return 'Pengundang berhasil ditautkan: $inviterId';
  }

  @override
  String get profilePageReferralProgressHint =>
      'Setelah menyelesaikan 15 pesan obrolan, kedua pihak masing-masing akan menerima 50 Bunga';

  @override
  String get profilePageAlreadyCheckedIn =>
      'Kamu sudah melakukan check-in hari ini';

  @override
  String get profilePageReferralBindFailed =>
      'Gagal menautkan. Silakan coba lagi nanti.';

  @override
  String get profilePageCharacterNotFound =>
      'Data karakter ini tidak ditemukan';

  @override
  String get periodGuideTitle =>
      'Bagaimana cara menggunakan Catatan Menstruasi?';

  @override
  String get periodGuideContent =>
      '① Pilih tanggal pada kalender terlebih dahulu.\n② Pilih “Mulai Hari Ini”, “Masih Menstruasi”, atau “Berakhir Hari Ini”.\n③ Pilih suasana hati dan kondisi fisikmu hari ini. Kamu juga dapat menambahkan catatan sendiri.\n④ Tekan Simpan agar karakter dapat memahami kondisimu hari ini saat mengobrol.\n\nTanggal prediksi akan disesuaikan berdasarkan riwayat catatanmu dan hanya digunakan sebagai referensi untuk pencatatan pribadi.';

  @override
  String get periodGotIt => 'Saya Mengerti';

  @override
  String get periodSelectAtLeastOne =>
      'Pilih setidaknya satu item untuk dicatat';

  @override
  String get periodFutureDateError =>
      'Status menstruasi tidak dapat ditandai pada tanggal mendatang.';

  @override
  String get periodAlreadyOngoingError =>
      'Sudah ada periode menstruasi yang berlangsung. Selesaikan periode tersebut terlebih dahulu.';

  @override
  String get periodNoOngoingError =>
      'Saat ini tidak ada periode menstruasi yang berlangsung. Pilih “Mulai Hari Ini” terlebih dahulu.';

  @override
  String get periodBeforeStartError =>
      'Tanggal tidak boleh lebih awal dari tanggal dimulainya periode menstruasi saat ini.';

  @override
  String get periodEndBeforeStartError =>
      'Tanggal berakhir tidak boleh lebih awal dari tanggal mulai.';

  @override
  String periodRecordSaved(String date) {
    return 'Catatan untuk $date telah disimpan';
  }

  @override
  String get periodSaveFailed => 'Gagal menyimpan. Silakan coba lagi nanti';

  @override
  String get periodDeleteTitle => 'Hapus catatan menstruasi ini?';

  @override
  String get periodDeleteContent =>
      'Setelah dihapus, rata-rata siklus dan prediksi berikutnya akan dihitung ulang.';

  @override
  String get periodCancel => 'Batal';

  @override
  String get periodDelete => 'Hapus';

  @override
  String get periodNoOngoing =>
      'Saat ini tidak ada periode menstruasi yang berlangsung';

  @override
  String periodDayCount(int count) {
    return 'Hari ke-$count menstruasi';
  }

  @override
  String get periodHelp => 'Petunjuk Penggunaan';

  @override
  String get periodAverageCycle => 'Rata-rata Siklus';

  @override
  String get periodAverageDuration => 'Rata-rata Durasi Menstruasi';

  @override
  String periodDays(int count) {
    return '$count hari';
  }

  @override
  String get periodNextPrediction => 'Prediksi Berikutnya';

  @override
  String get periodCalculatedAfterRecording => 'Dihitung setelah pencatatan';

  @override
  String get periodInsufficientData =>
      'Data saat ini belum mencukupi. Untuk sementara, prediksi akan menggunakan siklus 28 hari dan durasi menstruasi 5 hari.';

  @override
  String get periodPredictionDisclaimer =>
      'Prediksi dibuat berdasarkan catatan yang tersedia. Tanggal hanya digunakan sebagai referensi untuk pencatatan pribadi.';

  @override
  String get periodStartedToday => '🩸 Mulai Hari Ini';

  @override
  String get periodStillOngoing => 'Masih Menstruasi';

  @override
  String get periodEndedToday => 'Berakhir Hari Ini';

  @override
  String get periodDateNotReached => 'Hari ini belum tiba～';

  @override
  String get periodDateBeforeStart =>
      'Tanggal ini lebih awal dari tanggal dimulainya periode menstruasi saat ini.';

  @override
  String get periodMoodOkay => 'Cukup Baik';

  @override
  String get periodMoodHappy => 'Senang';

  @override
  String get periodMoodLow => 'Sedih';

  @override
  String get periodMoodUnwell => 'Tidak Enak Badan';

  @override
  String get periodMoodIrritable => 'Mudah Kesal';

  @override
  String get periodMoodTired => 'Lelah';

  @override
  String get periodMoodAnxious => 'Cemas';

  @override
  String get periodSymptomAbdominalPain => 'Sakit Perut';

  @override
  String get periodSymptomLowerBackPain => 'Nyeri Pinggang';

  @override
  String get periodSymptomHeadache => 'Sakit Kepala';

  @override
  String get periodSymptomBreastTenderness => 'Nyeri Payudara';

  @override
  String get periodSymptomSwelling => 'Bengkak';

  @override
  String get periodSymptomSleepy => 'Mengantuk';

  @override
  String get periodSymptomIncreasedAppetite => 'Nafsu Makan Meningkat';

  @override
  String get periodSymptomDigestiveDiscomfort => 'Gangguan Pencernaan';

  @override
  String periodDiaryTitle(String characterName) {
    return 'Catatan Perhatian dari $characterName';
  }

  @override
  String get periodLoadFailed =>
      'Gagal memuat catatan. Silakan coba lagi nanti';

  @override
  String get periodWeekdaySun => 'Min';

  @override
  String get periodWeekdayMon => 'Sen';

  @override
  String get periodWeekdayTue => 'Sel';

  @override
  String get periodWeekdayWed => 'Rab';

  @override
  String get periodWeekdayThu => 'Kam';

  @override
  String get periodWeekdayFri => 'Jum';

  @override
  String get periodWeekdaySat => 'Sab';

  @override
  String get periodSaveInstruction =>
      'Setelah memilih status, tekan “Simpan Catatan Hari Ini” di bagian bawah untuk menyimpannya.';

  @override
  String get periodTodayMood =>
      'Suasana Hati Hari Ini (Boleh pilih lebih dari satu)';

  @override
  String get periodMoodDescription =>
      'Ini adalah catatan harian untuk hari tersebut, bukan ikon yang ditampilkan pada kalender.';

  @override
  String get periodOtherMood => 'Suasana Hati Lainnya';

  @override
  String get periodOtherMoodHint => 'Contoh: merasa tersakiti, tidak aman……';

  @override
  String get periodTodaySymptoms =>
      'Kondisi Fisik Hari Ini (Boleh pilih lebih dari satu)';

  @override
  String get periodOtherSymptom => 'Kondisi Fisik Lainnya';

  @override
  String get periodOtherSymptomHint =>
      'Contoh: merasa kedinginan, tidak nafsu makan……';

  @override
  String periodNoteForCharacter(String characterName) {
    return 'Hal yang ingin kamu sampaikan kepada $characterName (Opsional)';
  }

  @override
  String get periodNoteHint =>
      'Contoh: hari ini aku ingin beristirahat dengan tenang dan tidak ingin didesak……';

  @override
  String get periodSaving => 'Menyimpan…';

  @override
  String get periodSaveToday => 'Simpan Catatan Hari Ini';

  @override
  String get periodHistory => 'Riwayat Menstruasi';

  @override
  String get periodOngoing => 'Sedang Berlangsung';

  @override
  String periodTotalDays(int count) {
    return 'Total $count hari';
  }

  @override
  String get periodDeleteRecord => 'Hapus Catatan';

  @override
  String get privateProfilePleaseSignIn => 'Silakan masuk terlebih dahulu';

  @override
  String privateProfileLoreLoadFailed(String error) {
    return 'Gagal memuat Fragmen Memori: $error';
  }

  @override
  String privateProfileWriteNewLore(int count, int limit) {
    return 'Tulis Fragmen Memori Baru ($count / $limit)';
  }

  @override
  String get privateProfileNoLore => 'Belum ada Fragmen Memori';

  @override
  String get privateProfileNoLoreHint =>
      'Kamu dapat mengatur pengaturan uji coba, petunjuk cerita, dan kenangan penting karakter di sini.';

  @override
  String get privateProfileUntitledLore => 'Fragmen Tanpa Judul';

  @override
  String get privateProfileEdit => 'Edit';

  @override
  String get privateProfileDelete => 'Hapus';

  @override
  String get privateProfileAddLore => 'Tambahkan Fragmen Memori';

  @override
  String get privateProfileLoreTitle => 'Judul';

  @override
  String get privateProfileLoreTeaser => 'Petunjuk Singkat';

  @override
  String get privateProfileLoreContent => 'Isi Lengkap';

  @override
  String get privateProfileLockLore => 'Kunci Fragmen';

  @override
  String get privateProfileLockLoreHint =>
      'Karakter pribadi saat ini hanya dapat dilihat oleh kreator. Kolom ini akan tetap disimpan agar dapat digunakan saat karakter dijadikan publik.';

  @override
  String get privateProfileCancel => 'Batal';

  @override
  String get privateProfileTitleContentRequired =>
      'Silakan masukkan judul dan isi';

  @override
  String get privateProfileLoreAdded => 'Fragmen Memori telah ditambahkan';

  @override
  String get privateProfileAddFailed =>
      'Gagal menambahkan. Silakan coba lagi nanti';

  @override
  String get privateProfilePublish => 'Publikasikan';

  @override
  String get privateProfileDeleteLoreTitle => 'Hapus Fragmen Memori';

  @override
  String get privateProfileDeleteLoreConfirm =>
      'Yakin ingin menghapus Fragmen Memori ini secara permanen?';

  @override
  String get privateProfileLoreDeleted => 'Fragmen Memori telah dihapus';

  @override
  String get privateProfileDeleteFailed =>
      'Gagal menghapus. Silakan coba lagi nanti';

  @override
  String get privateProfileEditLore => 'Edit Fragmen Memori';

  @override
  String get privateProfileSave => 'Simpan';

  @override
  String get editProfileBirthdayReminderTitle => '🎂 Pengingat Kecil';

  @override
  String get editProfileBirthdayReminderContent =>
      'Tanggal lahirmu akan memengaruhi ucapan ulang tahun dari karakter, hadiah ulang tahun, dan acara terkait.\n\nSebaiknya pastikan tanggal lahirmu sudah benar sebelum menyelesaikan pengaturan\nagar hadiah ulang tahun berikutnya tidak terpengaruh.';

  @override
  String get editProfileGotIt => 'Saya Mengerti';

  @override
  String get editProfileBirthdayConfirmTitle => '🎂 Konfirmasi Tanggal Lahir';

  @override
  String get editProfileBirthdayConfirmContent =>
      'Pastikan tanggal lahirmu sudah benar.\n\nTanggal lahir akan digunakan untuk ucapan ulang tahun, hadiah ulang tahun, dan acara terkait.\n\nUntuk mencegah hadiah ulang tahun diterima lebih dari satu kali, tanggal lahir tidak dapat diubah lagi setelah pengaturan selesai.\n\nYakin ingin menggunakan tanggal lahir ini?';

  @override
  String get editProfileReturnToEdit => 'Kembali untuk Mengedit';

  @override
  String get editProfileConfirmSetting => 'Konfirmasi Pengaturan';

  @override
  String get editProfileDefaultNickname => 'Pengembara yang Baru Dikenal';

  @override
  String get editProfileNoChanges => 'Tidak ada perubahan yang perlu disimpan';

  @override
  String editProfileCreateFailed(String error) {
    return 'Gagal membuat data: $error';
  }

  @override
  String editProfileAvatarNumber(int number) {
    return 'Avatar $number';
  }

  @override
  String get editProfileImageSelectionFailed =>
      'Gagal memilih gambar. Silakan pilih gambar lain';

  @override
  String get editProfileCancel => 'Batal';

  @override
  String get editProfileConfirm => 'Konfirmasi';

  @override
  String get editProfileImageProcessingFailed =>
      'Gagal memproses gambar. Silakan pilih gambar lain';

  @override
  String editProfileLoadFailed(String error) {
    return 'Gagal memuat data: $error';
  }

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHelper =>
      'Perkenalkan dirimu atau gaya kreatifmu secara singkat';

  @override
  String get editProfileBioHint =>
      'Contoh: Saya suka menciptakan karakter romansa fantasi, obsesif, dan imersif.';

  @override
  String get editProfileUserNotFound => 'Pengguna tidak ditemukan';

  @override
  String get editProfileGenerateIdFailed =>
      'Gagal membuat ID Pemain. Silakan coba lagi';

  @override
  String get editProfileSignedInUserNotFound =>
      'Pengguna yang sedang masuk tidak ditemukan';

  @override
  String editProfileAvatarReadFailed(int statusCode) {
    return 'Gagal memuat avatar. Kode status: $statusCode';
  }

  @override
  String editProfileAvatarFileNotFound(String path) {
    return 'File avatar yang dipilih tidak ditemukan: $path';
  }

  @override
  String get editProfileAvatarEmpty => 'Data gambar avatar kosong';

  @override
  String get chatPageSendFailed => 'Gagal mengirim. Silakan coba lagi nanti 😢';

  @override
  String get chatPageRegenerateFailed =>
      'Gagal membuat ulang. Pesan asli tetap disimpan. Silakan coba lagi.';

  @override
  String get chatPageRegenerating => '💭 Sedang berpikir ulang...';

  @override
  String get chatPageThinkingTooLong =>
      'Sepertinya dia sedang berpikir keras. Silakan coba lagi nanti……';

  @override
  String get chatPageAlreadyReplying =>
      'Dia sedang membalas. Tunggu sebentar dan jangan mengirim ulang.';

  @override
  String get chatPageMediaUploadFailed =>
      'Gagal mengunggah media. Silakan coba lagi.';

  @override
  String get chatPageReportReceived =>
      'Terima kasih atas laporanmu. Kami akan memeriksanya sesegera mungkin.';

  @override
  String chatPageMessagesDeleted(int count) {
    return '✅ Berhasil menghapus $count pesan';
  }

  @override
  String chatPageSelectPhotoFailed(String error) {
    return 'Tidak dapat memilih foto: $error';
  }

  @override
  String get chatPageRecordingNotFound => 'File rekaman tidak ditemukan';

  @override
  String get chatPageRecordingEmpty => 'File rekaman kosong';

  @override
  String chatPageAudioPlaybackFailed(String error) {
    return 'Gagal memutar audio: $error';
  }

  @override
  String get chatPageMicrophonePermissionRequired =>
      'Izin mikrofon diperlukan untuk merekam audio';

  @override
  String chatPageStartRecordingFailed(String error) {
    return 'Tidak dapat memulai perekaman: $error';
  }

  @override
  String get chatPageRecordingCreationFailed =>
      'Gagal membuat file rekaman. Silakan rekam ulang.';

  @override
  String chatPageRecordingFailed(String error) {
    return 'Perekaman gagal: $error';
  }

  @override
  String get chatPageRecordingNotFoundRetry =>
      'File rekaman tidak ditemukan. Silakan rekam ulang.';

  @override
  String get chatPageRecordingEmptyRetry =>
      'File rekaman kosong. Silakan rekam ulang.';

  @override
  String get chatPageNoRecordingToSend =>
      'Tidak ada rekaman yang dapat dikirim';

  @override
  String chatPagePointCost(int count) {
    return '$count poin';
  }

  @override
  String get chatPageVoiceUploading => 'Mengunggah rekaman suara……';

  @override
  String get chatPageChangeWatermarkColor => 'Ubah Warna Tanda Air';

  @override
  String chatPageMinutesSeconds(int minutes, int seconds) {
    return '$minutes menit $seconds detik';
  }

  @override
  String chatPageSeconds(int seconds) {
    return '$seconds detik';
  }

  @override
  String get characterEditSelectSupportingCharacter =>
      'Silakan pilih karakter pendukung.';

  @override
  String get characterEditSelectGender => 'Silakan pilih gender karakter.';

  @override
  String get characterEditCharacterSettings => 'Pengaturan Karakter';

  @override
  String get characterEditWorldview => 'Latar Dunia';

  @override
  String get characterEditSettingsMinLength =>
      'Pengaturan karakter harus berisi setidaknya 10 karakter.';

  @override
  String get characterEditWorldviewMinLength =>
      'Latar dunia harus berisi setidaknya 20 karakter.';

  @override
  String get characterEditSupportingCharacters => 'Karakter Pendukung';

  @override
  String get characterEditCharacterImage => 'Gambar Karakter';

  @override
  String get characterEditWorldviewHint =>
      'Jelaskan latar belakang, sejarah, zaman, wilayah, faksi, sistem, teknologi, sihir, dan aturan dunia.';

  @override
  String get characterEditSettingsHint =>
      'Jelaskan kepribadian, nilai-nilai, cara berpikir, reaksi emosional, kebiasaan perilaku, cara berbicara, dan keyakinan utama karakter.';

  @override
  String get characterEditUnknownCharacter => 'Karakter Tidak Dikenal';

  @override
  String get characterEditEditSupportingCharacter => 'Edit Karakter Pendukung';

  @override
  String get characterEditAddSupportingCharacter =>
      'Tambahkan Karakter Pendukung';

  @override
  String get characterEditSupportingCharacterName => 'Nama Karakter Pendukung';

  @override
  String get characterEditGender => 'Gender';

  @override
  String get characterEditMale => 'Laki-laki';

  @override
  String get characterEditFemale => 'Perempuan';

  @override
  String get characterEditOther => 'Lainnya';

  @override
  String get characterEditAge => 'Usia';

  @override
  String get characterEditIdentityOccupation => 'Identitas／Pekerjaan';

  @override
  String get characterEditRelationshipWithMain =>
      'Hubungan dengan Karakter Utama';

  @override
  String get characterEditRelationshipHint =>
      'Jelaskan masa lalu, posisi, perasaan, rahasia, dan hubungan saat ini dengan karakter utama.';

  @override
  String get characterEditCharacterProfile => 'Profil Karakter';

  @override
  String get characterEditCharacterProfileHint =>
      'Jelaskan kepribadian, penampilan, kebiasaan, nilai-nilai, kemampuan, kesukaan, hal yang tidak disukai, dan pengalaman penting karakter.';

  @override
  String get characterEditSpeakingStyle => 'Gaya Bicara';

  @override
  String get characterEditSpeakingStyleHint =>
      'Contoh: berbicara cepat, suka melontarkan komentar sarkastis, dan berbicara terus terang.';

  @override
  String get characterEditSupportingNameRequired =>
      'Silakan masukkan nama karakter pendukung.';

  @override
  String get characterEditSupportingGenderRequired =>
      'Silakan pilih gender karakter pendukung.';

  @override
  String get characterEditProfileRequired => 'Silakan isi profil karakter.';

  @override
  String get characterEditRelationshipTooLong =>
      'Deskripsi hubungan dengan karakter utama telah melebihi 1.500 karakter.';

  @override
  String get characterEditProfileTooLong =>
      'Profil karakter telah melebihi 1.500 karakter.';

  @override
  String get characterEditSave => 'Simpan';

  @override
  String get characterEditAdd => 'Tambahkan';

  @override
  String get creatorProfileNoBio => 'Belum ada bio';

  @override
  String get creatorProfileNoBioHint => 'Kreator ini belum menambahkan bio.';

  @override
  String get creatorProfileNoCreatorMoments =>
      'Kreator belum memublikasikan momen';

  @override
  String get creatorProfileNoCreatorMomentsHint =>
      'Konten publik yang dipublikasikan sebagai kreator akan muncul di sini.';

  @override
  String get creatorProfileNoCharacterMoments =>
      'Karakter milik kreator belum memublikasikan momen';

  @override
  String get creatorProfileNoCharacterMomentsHint =>
      'Konten yang dipublikasikan oleh karakter publik milik kreator akan muncul di sini.';

  @override
  String get creatorProfileNoPublicMoments => 'Belum ada momen publik';

  @override
  String get creatorProfileNoPublicMomentsHint =>
      'Momen publik yang dipublikasikan oleh kreator dan karakternya akan muncul di sini.';

  @override
  String get creatorProfilePublicWorks => 'Karya Publik';

  @override
  String get creatorProfileLikesReceived => 'Suka yang Diterima';

  @override
  String get creatorProfileFollow => 'Ikuti';

  @override
  String get creatorProfileFollowing => 'Mengikuti';

  @override
  String get creatorProfileUnfollowed => 'Berhenti mengikuti';

  @override
  String creatorProfileFollowedCreator(String creatorName) {
    return 'Mengikuti $creatorName';
  }

  @override
  String get creatorProfileOperationFailed =>
      'Operasi gagal. Silakan coba lagi nanti';

  @override
  String creatorProfileWorksLoadFailed(String error) {
    return 'Gagal memuat karya: $error';
  }

  @override
  String get characterProfileShareInvitation =>
      '🦋 Undangan pertemuan dari LoveyDovey';

  @override
  String characterProfileShareCreator(String creatorName) {
    return '✦ Kreator: $creatorName';
  }

  @override
  String characterProfileShareMessage(String characterName) {
    return 'Cari “$characterName” di LoveyDovey dan mulailah kisah yang hanya menjadi milik kalian berdua.';
  }

  @override
  String get characterProfileInvitationLabel => 'Kartu Undangan Karakter';

  @override
  String characterProfileCardCreator(String creatorName) {
    return 'Kreator  $creatorName';
  }

  @override
  String get characterProfileCardSearchHint =>
      'Cari karakter dan mulailah pertemuan  🦋';

  @override
  String get characterProfileScanToDownload => 'Pindai untuk Mengunduh';

  @override
  String characterProfileShareTitle(String characterName) {
    return 'Bagikan karakter “$characterName”';
  }

  @override
  String characterProfileShareSubject(String characterName) {
    return 'Temui $characterName di LoveyDovey';
  }

  @override
  String get characterProfileShareFailed =>
      'Gagal membuat kartu undangan. Silakan coba lagi nanti';

  @override
  String get characterProfilePrivateShareUnavailable =>
      'Karakter pribadi saat ini tidak dapat dibagikan';

  @override
  String get characterProfileShareCard => 'Bagikan Kartu Undangan';

  @override
  String get characterProfileShareCharacter => 'Bagikan Karakter';

  @override
  String get characterProfileReportCharacter => 'Laporkan Karakter';

  @override
  String get characterProfileTranslate => 'Terjemahkan';

  @override
  String get loginMethodInfoTooltip => 'Informasi Metode Login';

  @override
  String get characterEditCoreSetting => 'Pengaturan Inti Karakter';

  @override
  String get characterEditCoreSettingHint =>
      'Jelaskan kepribadian karakter, pola perilaku, cara berinteraksi dengan orang lain, dan gaya bicaranya.\n\nContoh: Dia terlihat dingin dan pendiam, tetapi sebenarnya sangat perhatian. Dia menjaga jarak dengan orang asing, merawat orang yang disukainya melalui tindakan, berbicara dengan singkat dan terus terang, serta tidak menggunakan panggilan yang terlalu manis atau genit.';

  @override
  String get characterEditNameDescription =>
      'Ini adalah nama karakter yang ditampilkan kepada publik. Sistem akan membuat nama pengguna karakter secara otomatis setelah karakter selesai dibuat.';

  @override
  String get characterEditNameHint => 'Masukkan nama karakter';

  @override
  String get characterEditAgeDescription =>
      'Tentukan usia karakter. Anda juga dapat mengisi usia yang terlihat sesuai dengan latar dunianya.';

  @override
  String get characterEditAgeHint => 'Contoh: 25';

  @override
  String get characterEditOccupationDescription =>
      'Identitas atau pekerjaan karakter saat ini, seperti pelajar, dokter, kesatria, atau pengusaha.';

  @override
  String get characterEditBirthdayDescription =>
      'Tentukan tanggal lahir karakter menggunakan empat digit atau pisahkan bulan dan tanggal dengan garis miring.';

  @override
  String get characterEditBirthdayHint => 'Contoh: 0825 atau 08/25';

  @override
  String get characterEditHeightDescription =>
      'Tentukan tinggi karakter dalam sentimeter.';

  @override
  String get characterEditHeightHint => 'Contoh: 182';

  @override
  String get characterEditGenderDescription =>
      'Sistem akan menggunakan kata ganti yang sesuai berdasarkan gender karakter.';

  @override
  String get characterEditAppearanceDescription =>
      'Jelaskan fitur wajah, gaya rambut, pakaian, dan ciri fisik karakter lainnya.';

  @override
  String get characterEditPlayerIdentityDescription =>
      'Tentukan identitas pemain dalam cerita, seperti asisten, teman sekelas, atau teman masa kecil.';

  @override
  String get characterEditWorldviewDescription =>
      'Jelaskan era, lokasi, latar sosial, dan aturan khusus dalam cerita. Konten ini akan ditampilkan secara publik pada bagian “Pengenalan Karakter” di halaman karakter, jadi hindari mencantumkan rahasia atau detail alur yang tidak ingin diketahui pemain sebelumnya.';

  @override
  String get characterEditStorySummaryDescription =>
      'Perkenalkan cerita secara singkat dalam satu kalimat agar situasi karakter dapat dipahami dengan cepat.';

  @override
  String get characterEditStorySummaryHint =>
      'Contoh: Kisah cinta yang dimulai dari hubungan kontrak dengan seorang dokter yang dingin';

  @override
  String get characterEditInitialStoryDescription =>
      'Situasi cerita yang akan dilihat pemain saat pertama kali memasuki ruang obrolan.';

  @override
  String get characterEditFirstLineDescription =>
      'Kalimat pertama yang diucapkan karakter saat pertama kali bertemu dengan pemain.';

  @override
  String get characterEditCustomStatusBar => 'Bilah Status Cerita (Opsional)';

  @override
  String get characterEditCustomStatusBarDescription =>
      'Hanya berlaku untuk Mode Cerita dan Mode Imersif. Anda dapat mengatur status, lokasi, pakaian, atau informasi hubungan karakter agar selalu ditampilkan di akhir balasan. Jika dibiarkan kosong, bilah status tidak akan dibuat.';

  @override
  String get characterProfileCharacterIntro => 'Pengenalan Karakter';

  @override
  String get characterProfileNoIntroduction =>
      'Kreator belum menambahkan pengenalan karakter';

  @override
  String get characterProfileViewMore => 'Lihat Selengkapnya';

  @override
  String get characterProfileCollapse => 'Tampilkan Lebih Sedikit';

  @override
  String get characterEditSelectedTagOrder =>
      'Seret tag yang dipilih untuk menyesuaikan urutan tampilannya';

  @override
  String get mailActivityGiftFallback => 'Hadiah Acara';

  @override
  String get mailFilterAll => 'Semua';

  @override
  String get mailFilterCollected => 'Tersimpan';

  @override
  String get mailCollectedEmptyTitle => 'Belum ada surat yang disimpan';

  @override
  String get mailCollectedEmptyHint =>
      'Buka surat yang ingin disimpan, lalu ketuk tombol simpan di sudut kanan atas.';

  @override
  String get mailQixiLimitedBadge => 'Edisi Terbatas Qixi';

  @override
  String get mailQixiThreeDayPromise => 'Qixi LoveyDovey・Janji Tiga Hari';

  @override
  String mailQixiFromCharacter(String characterName) {
    return 'Surat Qixi dari $characterName';
  }

  @override
  String mailFromCharacter(String characterName) {
    return 'Dari $characterName';
  }

  @override
  String get mailQixiCollectionLabel => 'Koleksi Terbatas Qixi 2026';

  @override
  String get mailShareGenerating => 'Membuat gambar untuk dibagikan……';

  @override
  String mailShareQixiMessage(String characterName) {
    return 'Aku menerima surat edisi terbatas Qixi dari $characterName 💌';
  }

  @override
  String get mailShareDefaultMessage => 'Surat dari 「LoveyDovey」💌';

  @override
  String get mailShareImageFailed =>
      'Gagal membuat gambar untuk dibagikan. Silakan coba lagi nanti';

  @override
  String get mailCollectedSuccess => 'Surat ini telah disimpan 💌';

  @override
  String get mailCollectedCancelled => 'Surat dihapus dari daftar tersimpan';

  @override
  String get mailCollectedUpdateFailed =>
      'Gagal memperbarui status penyimpanan. Silakan coba lagi nanti';

  @override
  String get mailRemoveCollectionTooltip => 'Hapus dari tersimpan';

  @override
  String get mailAddCollectionTooltip => 'Simpan surat';

  @override
  String get mailShareTooltip => 'Bagikan surat';

  @override
  String mailQixiDayNumber(int day) {
    return 'Hari ke-$day';
  }

  @override
  String get mailQixiDetailTitle => 'Surat Edisi Terbatas Qixi';

  @override
  String get mailQixiShareTooltip => 'Bagikan surat Qixi';

  @override
  String get qixiMaxThreeFriends =>
      'Dalam event ini, kamu hanya dapat memilih maksimal 3 karakter teman';

  @override
  String get qixiLoginRequired =>
      'Silakan masuk terlebih dahulu sebelum mengikuti event Qixi';

  @override
  String get qixiOutsideEventPeriod => 'Saat ini event Qixi belum berlangsung';

  @override
  String get qixiSelectAtLeastOne =>
      'Silakan pilih setidaknya satu karakter teman terlebih dahulu';

  @override
  String get qixiMysteryCharacter => 'Karakter Misterius';

  @override
  String qixiOpeningStory(String characterName) {
    return '(Menjelang Qixi, galaksi yang tertidur jauh di dalam malam perlahan terbangun. Cahaya bintang yang tersebar mulai berkumpul di sepanjang cakrawala, seolah menunggu dua orang yang bersedia memenuhi janji dan menuliskan nama satu sama lain.)\n\n(Konon, Jembatan Murai hanya akan menyala bagi mereka yang benar-benar ingin bertemu. Saat namamu dan nama \"$characterName\" muncul bersama di sungai bintang, seberkas cahaya lembut menembus malam dan jatuh ke ruang obrolan yang hanya menjadi milik kalian berdua.)\n\n(Mulai saat ini, kalian memiliki sebuah \"Janji Tiga Hari Qixi\". Harinya tidak perlu berurutan, dan kalian juga tidak perlu menyiapkan pengakuan cinta yang besar. Selama event berlangsung, cukup kembali ke sini pada tiga hari yang berbeda dan bagikan sebuah sapaan, perasaanmu, atau satu hal kecil yang terjadi hari ini.)\n\n(Setiap pertemuan yang berhasil akan menyalakan satu cahaya bintang di Jembatan Murai. Setelah ketiga cahaya bintang menyala, perasaan dan kenangan yang tersebar dalam percakapan kalian akan berubah menjadi sebuah surat terbatas Qixi yang ditulis khusus untukmu setelah hari ketiga yang diselesaikan berakhir.)\n\n(Saat ini, cahaya bintang pertama telah turun. Di ujung lain Jembatan Murai, \"$characterName\" tampaknya juga telah menerima janji ini.)\n\n——Janji Tiga Hari Qixi dimulai sekarang.';
  }

  @override
  String get qixiRoomOpenedLastMessage => 'Janji Tiga Hari Qixi telah dimulai';

  @override
  String get qixiCompanionSlotsFull =>
      'Semua slot pendamping Qixi telah dipilih';

  @override
  String get qixiSingleRoomOpened =>
      'Ruang obrolan khusus Qixi telah dibuka 💕';

  @override
  String qixiMultipleRoomsOpened(int count) {
    return '$count ruang obrolan khusus Qixi telah dibuka 💕';
  }

  @override
  String get qixiCreateRoomFailed =>
      'Gagal membuat ruang obrolan Qixi. Silakan coba lagi nanti';

  @override
  String get qixiEventStartsAt => 'Event dimulai pada 8/19 pukul 00:00';

  @override
  String get qixiEventActiveUntil =>
      'Event sedang berlangsung · Berakhir 8/26 pukul 23:59';

  @override
  String get qixiEventEnded => 'Event Qixi kali ini telah berakhir';

  @override
  String get qixiEventHeroTitle =>
      'Qixi Lovey Time · Bersamamu Menuju Jembatan Murai';

  @override
  String get qixiCharacterSelected => 'Dipilih';

  @override
  String get qixiFriendListLoadFailed =>
      'Gagal memuat daftar teman. Silakan coba lagi nanti';

  @override
  String get qixiNoFriendCharacters => 'Kamu belum memiliki karakter teman';

  @override
  String get qixiNoFriendCharactersHint =>
      'Temui dulu karakter yang kamu sukai, lalu kembali dan seberangi Jembatan Murai bersama!';

  @override
  String get qixiLoadingCharacter => 'Memuat data karakter……';

  @override
  String get qixiEventPageTitle => 'Event Terbatas Qixi';

  @override
  String get qixiEventRules =>
      'Selama event berlangsung, pilih 3 tanggal yang berbeda, kirim pesan di ruang obrolan khusus Qixi, dan berhasil menerima balasan dari karakter untuk menyalakan satu cahaya dari tiga hari. Surat terbatas akan dikirim setelah hari ketiga yang diselesaikan berakhir. Tanggal event dan progres harian mengikuti Waktu Taiwan (UTC+8).';

  @override
  String qixiSelectCompanions(int count) {
    return 'Pilih Pendamping ($count/3)';
  }

  @override
  String get qixiSelectionLockedHint =>
      'Kamu dapat memilih maksimal 3 karakter yang telah ditambahkan sebagai teman. Setelah dipilih, mereka tidak dapat diganti.';

  @override
  String get qixiConfirmCompanions => 'Konfirmasi Pendamping';

  @override
  String get encounterDailyQuote1 =>
      'Hari ini, mungkin ada kisah baru yang menunggumu.';

  @override
  String get encounterDailyQuote2 =>
      'Hari ini, biarkan hatimu berbicara lebih dulu.';

  @override
  String get encounterDailyQuote3 =>
      'Hari ini, mungkin ada seseorang yang sedang menunggu untuk bertemu denganmu.';

  @override
  String get encounterDailyQuote4 =>
      'Hari ini, cobalah melangkah masuk ke sebuah kisah baru.';

  @override
  String get encounterDailyQuote5 =>
      'Degup seperti apa yang akan kamu temui hari ini?';

  @override
  String get encounterDailyQuote6 =>
      'Hari ini, sisakan sedikit harapan untuk dirimu sendiri.';

  @override
  String get encounterDailyQuote7 =>
      'Hari ini, sebuah pertemuan baru sedang dimulai.';

  @override
  String get encounterDailyQuote8 =>
      'Hari ini, mungkin takdir membawa sedikit kejutan untukmu.';

  @override
  String get encounterDailyQuote9 =>
      'Hari ini, biarkan sebuah pertemuan dimulai perlahan.';

  @override
  String get encounterDailyQuote10 =>
      'Hari ini, mungkin ada seseorang yang membuatmu berhenti sejenak.';

  @override
  String get encounterDailyQuote11 => 'Siapa yang ingin kamu temui hari ini?';

  @override
  String get encounterDailyQuote12 =>
      'Hari ini, jangan lewatkan ikatan yang perlahan mendekat.';

  @override
  String get encounterJoinedToday => '✨ Bergabung dengan Lovey Time Hari Ini';

  @override
  String get encounterPopularChats => '❤️ Banyak Dibicarakan Akhir-Akhir Ini';

  @override
  String get qixiBannerActiveUntil =>
      'Waktu Terbatas · Hingga 8/26 pukul 23:59';

  @override
  String get qixiBannerStartsAt => 'Terbatas Mulai 8/19';

  @override
  String get encounterRecentlyArrived => '✨ Baru Tiba di Lovey Time';

  @override
  String get encounterRecentlyArrivedPlain => 'Baru Tiba di Lovey Time';

  @override
  String get encounterViewMore => 'Lihat Selengkapnya';

  @override
  String get encounterLovePrompt =>
      '💕 Kisah cinta seperti apa yang ingin kamu jalani hari ini?';

  @override
  String get encounterNoCharacters => 'Belum ada karakter';

  @override
  String get encounterAllLoveTags => 'Semua Tag Cinta';

  @override
  String get chatQixiLetterSent => 'Surat terbatas telah dikirim 💌';

  @override
  String get chatQixiLetterPendingTonight =>
      'Ketiga cahaya bintang telah menyala · Surat akan dikirim setelah malam ini';

  @override
  String get chatQixiTodayCompleted => 'Cahaya bintang hari ini telah menyala';

  @override
  String get chatQixiTodayNotCompleted => 'Progres hari ini belum selesai';

  @override
  String get chatQixiPromiseTitle => 'Qixi Lovey Time · Janji Tiga Hari';

  @override
  String chatQixiStarProgress(int count) {
    return 'Cahaya Bintang $count/3';
  }

  @override
  String get chatQixiProgressRule =>
      'Selesaikan obrolan pada tiga hari yang berbeda untuk menyalakan cahaya bintang. Surat terbatas akan dikirim setelah hari ketiga berakhir. Progres harian dihitung berdasarkan Waktu Taiwan (UTC+8).';

  @override
  String chatQixiDayNumber(int day) {
    return 'Hari $day';
  }

  @override
  String get chatWebPurchaseUnavailable =>
      'Pembelian saat ini tidak tersedia di versi web. Gunakan aplikasi Lovey Time untuk membeli Flowers atau berlangganan.';

  @override
  String get chatAiThinkingTimeout =>
      'Sepertinya dia sedang tenggelam dalam pikirannya. Coba lagi sebentar lagi……';

  @override
  String get chatAiResponseBlocked =>
      'Sepertinya pikirannya sedikit terganggu. Coba sampaikan kembali dengan cara yang lebih lembut.';

  @override
  String get chatRecordingStartFailed =>
      'Tidak dapat memulai rekaman. Silakan coba lagi nanti.';

  @override
  String get chatRecordingPlaybackFailed =>
      'Gagal memutar rekaman. Silakan coba lagi nanti.';

  @override
  String get chatRoomNotReady =>
      'Ruang obrolan belum siap. Silakan coba lagi nanti.';

  @override
  String get chatRegenerateLimitReached =>
      'Kesempatan regenerasi hari ini sudah habis';

  @override
  String get chatTypingIndicator => 'Dia sedang mengetik……';

  @override
  String get chatRegenerateCountSyncFailed =>
      'Regenerasi berhasil, tetapi jumlahnya gagal disinkronkan. Silakan muat ulang nanti.';

  @override
  String get chatRoomNotFound =>
      'Ruang obrolan untuk karakter ini tidak ditemukan';

  @override
  String get momentsSearchTooltip => 'Cari di Dinding Momen';

  @override
  String get momentsCreatorNotFound => 'Informasi kreator ini tidak ditemukan';

  @override
  String get momentCommentLoadFailed =>
      'Gagal memuat komentar. Silakan coba lagi nanti';

  @override
  String get momentCollapseReplies => 'Tutup balasan';

  @override
  String momentViewOtherReplies(int count) {
    return 'Lihat $count balasan lainnya';
  }

  @override
  String get momentSwitchCommentIdentity => 'Ganti identitas komentar';

  @override
  String get momentSendCommentTooltip => 'Kirim komentar';

  @override
  String get momentShareCharactersLoadFailed =>
      'Gagal memuat karakter chat. Silakan coba lagi nanti';

  @override
  String get momentReportLoginRequired =>
      'Silakan masuk terlebih dahulu sebelum melaporkan postingan ini';

  @override
  String get momentReportSubmitted =>
      'Laporan telah dikirim. Kami akan meninjaunya';

  @override
  String get momentSelectShareCharacter =>
      'Pilih karakter yang pernah kamu ajak mengobrol untuk membagikan postingan ini';

  @override
  String get momentTagCharacterUnavailable =>
      'Tag ini tidak terhubung ke profil karakter';

  @override
  String get momentCharacterNotFound => 'Data karakter tidak ditemukan';

  @override
  String get appUpdateTitle => 'Versi baru tersedia';

  @override
  String get appUpdateMessage =>
      'Versi baru LoveyDovey telah tersedia. Perbarui sekarang untuk mendapatkan fitur dan perbaikan terbaru.';

  @override
  String get appUpdateLater => 'Nanti';

  @override
  String get appUpdateGo => 'Perbarui sekarang';

  @override
  String get appUpdateCurrentVersion => 'Versi saat ini';

  @override
  String get appUpdateLatestVersion => 'Versi terbaru';

  @override
  String get appUpdateStoreOpenFailed =>
      'Toko tidak dapat dibuka saat ini. Silakan coba lagi nanti.';
}
