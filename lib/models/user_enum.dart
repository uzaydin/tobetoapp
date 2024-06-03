// ignore_for_file: constant_identifier_names

// Kullanıcı role 
enum UserRole {
  student,
  teacher,
  admin,
}

extension UserRoleExtension on UserRole {
  static UserRole fromName(String name) {
    return UserRole.values.firstWhere((role) => role.name == name);
  }

  String toName() {
    return name;
  }
}

enum Gender { Erkek, Kadin, BelirtmekIstemiyorum }

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.Erkek:
        return 'Erkek';
      case Gender.Kadin:
        return 'Kadın';
      case Gender.BelirtmekIstemiyorum:
        return 'Belirtmek İstemiyorum';
      default:
        return '';
    }
  }

  static Gender fromName(String name) {
    switch (name) {
      case 'Erkek':
        return Gender.Erkek;
      case 'Kadın':
        return Gender.Kadin;
      case 'Belirtmek İstemiyorum':
        return Gender.BelirtmekIstemiyorum;
      default:
        throw ArgumentError('Unknown gender: $name');
    }
  }
}

enum MilitaryStatus { Yapti, Tecilli, Muaf }

extension MilitaryStatusExtension on MilitaryStatus {
  String get name {
    switch (this) {
      case MilitaryStatus.Yapti:
        return 'Yaptı';
      case MilitaryStatus.Tecilli:
        return 'Tecilli';
      case MilitaryStatus.Muaf:
        return 'Muaf';
      default:
        return '';
    }
  }

  static MilitaryStatus fromName(String name) {
    switch (name) {
      case 'Yaptı':
        return MilitaryStatus.Yapti;
      case 'Tecilli':
        return MilitaryStatus.Tecilli;
      case 'Muaf':
        return MilitaryStatus.Muaf;
      default:
        throw ArgumentError('Unknown military status: $name');
    }
  }
}

enum DisabilityStatus { Var, Yok }

extension DisabilityStatusExtension on DisabilityStatus {
  String get name {
    switch (this) {
      case DisabilityStatus.Var:
        return 'Var';
      case DisabilityStatus.Yok:
        return 'Yok';
      default:
        return '';
    }
  }

  static DisabilityStatus fromName(String name) {
    switch (name) {
      case 'Var':
        return DisabilityStatus.Var;
      case 'Yok':
        return DisabilityStatus.Yok;
      default:
        throw ArgumentError('Unknown disability status: $name');
    }
  }
}

//ŞEHİRLER VE İLLER GELEBİLİR

enum ExperienceType { Staj, GonulluCalisma, ProfosyonelCalisma }

extension ExperienceTypeExtension on ExperienceType {
  String get name {
    switch (this) {
      case ExperienceType.Staj:
        return 'Staj';
      case ExperienceType.GonulluCalisma:
        return 'Gönüllü Çalışma';
      case ExperienceType.ProfosyonelCalisma:
        return 'Profesyonel Çalışma';
      default:
        return '';
    }
  }

  static ExperienceType fromName(String name) {
    switch (name) {
      case 'Staj':
        return ExperienceType.Staj;
      case 'Gönüllü Çalışma':
        return ExperienceType.GonulluCalisma;
      case 'Profesyonel Çalışma':
        return ExperienceType.ProfosyonelCalisma;
      default:
        throw ArgumentError('Invalid experience type name');
    }
  }
}

enum EducationStatus { Lisans, OnLisans, YuksekLisans, Doktora }

extension EducationStatusExtension on EducationStatus {
  String get name {
    switch (this) {
      case EducationStatus.Lisans:
        return 'Lisans';
      case EducationStatus.OnLisans:
        return 'Ön Lisans';
      case EducationStatus.YuksekLisans:
        return 'Yüksek Lisans';
      case EducationStatus.Doktora:
        return 'Doktora';
      default:
        return '';
    }
  }

  static EducationStatus fromName(String name) {
    switch (name) {
      case 'Lisans':
        return EducationStatus.Lisans;
      case 'Ön Lisans':
        return EducationStatus.OnLisans;
      case 'Yüksek Lisans':
        return EducationStatus.YuksekLisans;
      case 'Doktora':
        return EducationStatus.Doktora;
      default:
        throw ArgumentError('Invalid education status name');
    }
  }
}

enum Skill {
  CSharp,
  SQL,
  Muhasebe,
  Javascript,
  AktifOgrenme,
  AktifDinleme,
  UyumSaglama,
  YonetimVeIdare,
  Reklam,
  Algoritmalar,
  Android,
  ApacheAmbari,
  UygulamaMagazasiIOS,
  AppleSaglikKiti,
  AppleIOS,
  AppleXcode,
  UygulamaliMakineOgrenimi,
  BackEnd,
  BuyukVeri,
  BlokZinciri,
  MarkaYonetimi,
  Iletisim,
  Pazarlama,
  BuildingAndConstruction,
  CSS
}

extension SkillExtension on Skill {
  String get name {
    switch (this) {
      case Skill.CSharp:
        return 'C#';
      case Skill.SQL:
        return 'SQL';
      case Skill.Muhasebe:
        return 'Muhasebe';
      case Skill.Javascript:
        return 'Javascript';
      case Skill.AktifOgrenme:
        return 'Aktif Öğrenme';
      case Skill.AktifDinleme:
        return 'Aktif Dinleme';
      case Skill.UyumSaglama:
        return 'Uyum Sağlama';
      case Skill.YonetimVeIdare:
        return 'Yönetim ve İdare';
      case Skill.Reklam:
        return 'Reklam';
      case Skill.Algoritmalar:
        return 'Algoritmalar';
      case Skill.Android:
        return 'Android';
      case Skill.ApacheAmbari:
        return 'Apache Ambari';
      case Skill.UygulamaMagazasiIOS:
        return 'Uygulama Mağazası (IOS)';
      case Skill.AppleSaglikKiti:
        return 'Apple Sağlık Kiti';
      case Skill.AppleIOS:
        return 'Apple IOS';
      case Skill.AppleXcode:
        return 'Apple Xcode';
      case Skill.UygulamaliMakineOgrenimi:
        return 'Uygulamalı Makine Öğrenimi';
      case Skill.BackEnd:
        return 'Back End (Yazılım Mühendisliği)';
      case Skill.BuyukVeri:
        return 'Büyük Veri';
      case Skill.BlokZinciri:
        return 'Blok Zinciri';
      case Skill.MarkaYonetimi:
        return 'Marka Yönetimi';
      case Skill.Iletisim:
        return 'İletişim';
      case Skill.Pazarlama:
        return 'Pazarlama';
      case Skill.BuildingAndConstruction:
        return 'Building and Construction';
      case Skill.CSS:
        return 'CSS';
      default:
        return '';
    }
  }

  static Skill fromName(String name) {
    return Skill.values.firstWhere((skill) => skill.name == name,
        orElse: () => throw ArgumentError('Invalid skill name: $name'));
  }
}

enum SocialMediaPlatform {
  Instagram,
  Twitter,
  LinkedIn,
  Dribble,
  Behance,
}

extension SocialMediaPlatformExtension on SocialMediaPlatform {
  String get name {
    switch (this) {
      case SocialMediaPlatform.Instagram:
        return 'Instagram';
      case SocialMediaPlatform.Twitter:
        return 'Twitter';
      case SocialMediaPlatform.LinkedIn:
        return 'LinkedIn';
      case SocialMediaPlatform.Dribble:
        return 'Dribble';
      case SocialMediaPlatform.Behance:
        return 'Behance';
      default:
        return '';
    }
  }

  static SocialMediaPlatform fromName(String name) {
    switch (name) {
      case 'Instagram':
        return SocialMediaPlatform.Instagram;
      case 'Twitter':
        return SocialMediaPlatform.Twitter;
      case 'LinkedIn':
        return SocialMediaPlatform.LinkedIn;
      case 'Dribble':
        return SocialMediaPlatform.Dribble;
      case 'Behance':
        return SocialMediaPlatform.Behance;
      default:
        throw Exception('Invalid social media platform');
    }
  }
}

// Yabancı Diller Enum
enum Language {
  Arapca,
  Ingilizce,
  Rusca,
  // Diğer diller buraya eklenebilir
}

extension LanguageExtension on Language {
  String get name {
    switch (this) {
      case Language.Arapca:
        return 'Arapça';
      case Language.Ingilizce:
        return 'İngilizce';
      case Language.Rusca:
        return 'Rusça';
      // Diğer diller buraya eklenebilir
      default:
        return '';
    }
  }

  static Language fromName(String name) {
    switch (name) {
      case 'Arapça':
        return Language.Arapca;
      case 'İngilizce':
        return Language.Ingilizce;
      case 'Rusça':
        return Language.Rusca;
      default:
        throw Exception('Invalid language name');
    }
  }
}

// Dil Yeterlilik Seviyeleri Enum
enum ProficiencyLevel {
  TemelSeviyeA1A2,
  OrtaSeviyeB1B2,
  IleriSeviyeC1C2,
  AnaDil,
}

extension ProficiencyLevelExtension on ProficiencyLevel {
  String get name {
    switch (this) {
      case ProficiencyLevel.TemelSeviyeA1A2:
        return 'Temel Seviye (A1-A2)';
      case ProficiencyLevel.OrtaSeviyeB1B2:
        return 'Orta Seviye (B1-B2)';
      case ProficiencyLevel.IleriSeviyeC1C2:
        return 'İleri Seviye (C1-C2)';
      case ProficiencyLevel.AnaDil:
        return 'Ana Dil';
      default:
        return '';
    }
  }

  static ProficiencyLevel fromName(String name) {
    switch (name) {
      case 'Temel Seviye (A1-A2)':
        return ProficiencyLevel.TemelSeviyeA1A2;
      case 'Orta Seviye (B1-B2)':
        return ProficiencyLevel.OrtaSeviyeB1B2;
      case 'İleri Seviye (C1-C2)':
        return ProficiencyLevel.IleriSeviyeC1C2;
      case 'Ana Dil':
        return ProficiencyLevel.AnaDil;
      default:
        throw Exception('Invalid proficiency level name');
    }
  }
}
