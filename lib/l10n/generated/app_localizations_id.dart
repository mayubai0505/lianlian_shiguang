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
  String get charNameLabel => 'Nama Karakter:*';

  @override
  String get charDescSection => 'Deskripsi Karakter:';

  @override
  String get charAgeLabel => 'Usia:';

  @override
  String get charJobLabel => 'Pekerjaan:*';

  @override
  String get charBirthdayLabel => 'Tanggal Lahir:(MMDD)';

  @override
  String get charGenderLabel => 'Jenis Kelamin *';

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
      'Karakter dan adegan dalam game ini adalah fiksi, jangan diterapkan pada kenyataan! Jika ada kesamaan, itu murni kebetulan.';

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
  String get terms_title => 'Ketentuan Layanan Lianlian Shiguang';

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
      '✅ Data suara berhasil diunduh, bersiap untuk memutar...';

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
  String get test_mode_error =>
      '⚠️ File karakter tidak ditemukan! Silakan klik \"Simpan/Publikasikan\" di bagian bawah sebelum mencoba tes!';

  @override
  String get test_mode_notice =>
      '💡 Mode tes akan memotong poin sesuai harga asli setiap mode, dan tidak akan dihitung dalam ingatan resmi!';

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
  String get section_story_identity => '🎭 Cerita dan Identitas Anda';

  @override
  String get story_identity_desc =>
      'Tentukan pembukaan cerita dan pengaturan khusus untuk \"Anda\" di simpanan ini';

  @override
  String get advanced_writing_tips_title => '💡 Tips Menulis Lanjutan:\n';

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
  String get player_identity_label =>
      'Identitas Default Pemain (Player Identity) - 💡 Opsional';

  @override
  String get player_identity_hint =>
      '【Opsional】Jika dikosongkan, AI akan membaca \"Profil\" Anda untuk berinteraksi.\nJika diisi, akan memaksa peran identitas tertentu (Contoh: sistemnya yang dingin, atau istri yang dikhianati).';

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
  String get section_personality_evo => '🌟 Evolusi Kepribadian & Afeksi';

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
  String get section_habits => '🗣️ Kesukaan & Kebiasaan';

  @override
  String get tone_hint_detail =>
      'Wajib diisi. Contoh: Berbicara singkat, suka bertanya balik. Kata andalannya adalah \"bodoh\". Dilarang menggunakan gaya bahasa terjemahan mesin.';

  @override
  String get dialogue_example_hint =>
      'Pemain: Aku lelah sekali.\nKarakter: (Mengelus kepala) Anak pintar, cepat istirahat.';

  @override
  String get section_easter_eggs => '🎁 Easter Egg & Cerita Spesial';

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
  String get section_voice_gen => '🎙️ Pembuatan Suara Eksklusif';

  @override
  String get voice_gen_desc =>
      'Masukkan kata perintah untuk memberinya suara yang unik di dunia!\n(💡 Tips: Jika tidak puas setelah dihasilkan, Anda dapat membuatnya ulang kapan saja!)';

  @override
  String get voice_generating_status => 'Sedang meramu suara...';

  @override
  String get voice_select_prompt =>
      '✨ Telah disiapkan tiga jenis suara untukmu, silakan pilih:';

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
  String get voice_advanced_tuning => '🎛️ Lanjutan: Penyesuaian Emosi Bicara';

  @override
  String get voice_stability_low => 'Liar/Napas 🐺';

  @override
  String voice_stability_value(String value) {
    return 'Rasionalitas: $value';
  }

  @override
  String get voice_stability_high => 'Stabil/Tenang 🤖';

  @override
  String get voice_style_low => 'Dingin/Tertekan 🧊';

  @override
  String voice_style_value(String value) {
    return 'Ekspresi Dramatis: $value';
  }

  @override
  String get voice_style_high => 'Lebay/Penuh Perasaan 🔥';

  @override
  String get voice_test_btn_testing => 'Menerapkan emosi...';

  @override
  String get voice_test_btn => 'Dengar emosi saat ini';

  @override
  String get section_social_circle => '👥 Lingkaran Sosialnya';

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
    return 'Edit pandangan terhadap $name 💬';
  }

  @override
  String get social_attitude_label => 'Pandangan / Sikapnya';

  @override
  String get social_attitude_hint =>
      'Contoh: Merasa orang itu berisik, tapi sebenarnya bergantung padanya...';

  @override
  String get social_save_changes => 'Simpan perubahan';

  @override
  String get social_add_title => 'Tambah Hubungan Karakter 🤝';

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
      'Gagal memuat gambar 🥲\nPastikan jaringan normal, jika menggunakan Web silakan cek console.';

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
      'Bagaimana menurutmu nada bicaraku sekarang? Jika kamu puas, mari kita tetapkan seperti ini.';

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
      'Tidak bisa menyukai karakter buatan sendiri! 🤭';

  @override
  String get like_success_msg =>
      'Suka telah dikirim! Kreator akan sangat senang 💖';

  @override
  String get unlike_success_msg => 'Batal menyukai 💔';

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
  String get report_title => '📢 Laporkan Komentar';

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
      'Laporan berhasil, notifikasi telah diterima! Konten akan segera ditinjau 🛡️';

  @override
  String get report_failed =>
      'Laporan gagal, silakan periksa koneksi internet.';

  @override
  String get lore_delete_title => '⚠️ Peringatan: Hapus Memori';

  @override
  String get lore_delete_content =>
      'Memori ini akan hilang sepenuhnya setelah dihapus, yakin ingin menghapusnya?';

  @override
  String get lore_delete_cancel => 'Salah tekan';

  @override
  String get lore_delete_confirm => 'Konfirmasi Hapus';

  @override
  String get lore_delete_success =>
      '🗑️ Fragmen memori telah dihapus sepenuhnya.';

  @override
  String get lore_add_title => 'Tulis Memori Baru 🖋️';

  @override
  String get lore_edit_title => 'Edit Fragmen Memori 🖋️';

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
  String get lore_lock_label => '🔒 Segel Memori Ini';

  @override
  String get lore_lock_desc =>
      'Setelah dicentang, hanya kreator yang bisa melihat, pemain tidak bisa melihatnya';

  @override
  String get lore_empty_error => 'Judul dan isi tidak boleh kosong!';

  @override
  String get lore_add_success => '✨ Memori baru telah berhasil disegel!';

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
      '🔒 Memori ini telah disegel, saat ini tidak dapat dilihat.';

  @override
  String get lore_not_open_msg => 'Memori ini belum dibuka untuk umum...';

  @override
  String get lore_unnamed => 'Fragmen Tanpa Nama';

  @override
  String get lore_add_btn_limit => 'Tulis fragmen memori baru (Maksimal 10)';

  @override
  String get lore_collapse => 'Tutup Surat';

  @override
  String get echo_delete_title => '🗑️ Hapus Komentar';

  @override
  String get echo_delete_content =>
      'Yakin ingin menghapus Gema Waktu ini?\nSetelah dihapus, tidak akan bisa dikembalikan lagi!';

  @override
  String get echo_keep => 'Simpan';

  @override
  String get echo_clear_success => 'Gema waktu telah dibersihkan 🧹';

  @override
  String get echo_energy_full_title => '⚠️ Energi Alam Semesta Mencapai Batas';

  @override
  String get echo_energy_full_content =>
      'Energi waktu Anda telah mencapai batas (Maksimal 3), hapus pengalaman lama Anda untuk membuka catatan alam semesta yang baru!';

  @override
  String get echo_write_title => 'Tinggalkan Gema Waktumu 🌌';

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
      'Kreator tidak bisa mengikuti diri sendiri! 🤭';

  @override
  String follow_success_msg(String playerName, String creatorName) {
    return '✨ $playerName mengikuti $creatorName!';
  }

  @override
  String get mailbox_follow_title => 'Mendapatkan Penjaga Baru 🦋';

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
  String get background_story_title => 'Cerita Latar Belakang';

  @override
  String get background_story_empty =>
      'Karakter ini misterius, belum ada cerita latar belakang...';

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
      '✅ Laporan telah dikirim, kami akan segera melakukan penyesuaian';

  @override
  String get chat_suggest_title => 'Beri saran';

  @override
  String get chat_suggest_hint => 'Silakan tuliskan masukan berharga Anda...';

  @override
  String get chat_suggest_success =>
      '💖 Terima kasih atas sarannya, kami akan segera memprosesnya';

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
  String get comment_report_rules_title => '⚖️ Aturan Pelaporan Komentar';

  @override
  String get comment_report_rules_desc =>
      '1️⃣ Pelanggaran 1: Peringatan sistem dan satu catatan pelanggaran.\n2️⃣ Pelanggaran 2: Dilarang berkomentar selama 1 hari.\n3️⃣ Pelanggaran Berulang: Fitur laporan dinonaktifkan selama 14 hari dan visibilitas komentar dikurangi.\n\n🚨 Untuk tindakan jahat yang parah:\nInteraksi dengan karakter dilarang selama 1 hari, dan ID akan dipajang di papan pengumuman selama 3 hari (dilarang mengganti ID selama periode ini).\n\n💡 Setelah laporan dikirim, hasil tinjauan akhir akan dikirimkan melalui [Email dalam game].\nHarap saling menghormati dan melaporlah dengan bijak.';

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
      'Lakukan 3 obrolan harian dengan karakter';

  @override
  String get tab_story_progression => 'Kemajuan Cerita';

  @override
  String get task_desc_story_1_time => 'Selesaikan 1 interaksi mode cerita';

  @override
  String get tab_social_tour => 'Tur Sosial';

  @override
  String get task_desc_like_3_moments => 'Sukai 3 postingan Momen';

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
}
