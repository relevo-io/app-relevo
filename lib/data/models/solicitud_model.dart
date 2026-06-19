import 'user_model.dart';
import 'offer_model.dart';

class ResultadoIa {
  final String resumen;
  final double nota;
  final String comentarioNota;
  final List<String> puntosFuertes;
  final List<String> experienciaDestacada;

  ResultadoIa({
    required this.resumen,
    required this.nota,
    required this.comentarioNota,
    required this.puntosFuertes,
    required this.experienciaDestacada,
  });

  factory ResultadoIa.fromJson(Map<String, dynamic> json) {
    return ResultadoIa(
      resumen: json['resumen'] ?? '',
      nota: json['nota'] != null ? (json['nota'] as num).toDouble() : 0.0,
      comentarioNota: json['comentarioNota'] ?? '',
      puntosFuertes: json['puntosFuertes'] != null
          ? List<String>.from(json['puntosFuertes'])
          : [],
      experienciaDestacada: json['experienciaDestacada'] != null
          ? List<String>.from(json['experienciaDestacada'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resumen': resumen,
      'nota': nota,
      'comentarioNota': comentarioNota,
      'puntosFuertes': puntosFuertes,
      'experienciaDestacada': experienciaDestacada,
    };
  }
}

class Solicitud {
  final String id;
  final User owner;
  final User interestedUser;
  final Offer opportunity;
  final String status;
  final String? message;
  final String? bio;
  final String? professionalBackground;
  final List<String>? preferredRegions;
  final double? availableCapital;
  final bool? financingNeeded;
  final bool? ndaAccepted;
  final String? cvKey;
  final String? estadoAnalisis;
  final ResultadoIa? resultadoIa;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Solicitud({
    required this.id,
    required this.owner,
    required this.interestedUser,
    required this.opportunity,
    required this.status,
    this.message,
    this.bio,
    this.professionalBackground,
    this.preferredRegions,
    this.availableCapital,
    this.financingNeeded,
    this.ndaAccepted,
    this.cvKey,
    this.estadoAnalisis,
    this.resultadoIa,
    this.createdAt,
    this.updatedAt,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    final dynamic rawOwner = json['owner'];
    final User parsedOwner = rawOwner is Map<String, dynamic>
        ? User.fromJson(rawOwner)
        : User(id: rawOwner?.toString() ?? '', fullName: '', email: '', roles: []);

    final dynamic rawUser = json['interestedUser'];
    final User parsedUser = rawUser is Map<String, dynamic>
        ? User.fromJson(rawUser)
        : User(id: rawUser?.toString() ?? '', fullName: '', email: '', roles: []);

    final dynamic rawOpp = json['opportunity'];
    final Offer parsedOpp = rawOpp is Map<String, dynamic>
        ? Offer.fromJson(rawOpp)
        : Offer(id: rawOpp?.toString() ?? '', region: '', sector: '', owner: '', companyDescription: '');

    final dynamic rawRegions = json['preferredRegions'];
    final List<String>? parsedRegions = rawRegions is List
        ? rawRegions.map((e) => e.toString()).toList()
        : null;

    final dynamic rawIa = json['resultadoIa'];
    final ResultadoIa? parsedIa = rawIa is Map<String, dynamic>
        ? ResultadoIa.fromJson(rawIa)
        : null;

    return Solicitud(
      id: json['_id'] ?? '',
      owner: parsedOwner,
      interestedUser: parsedUser,
      opportunity: parsedOpp,
      status: json['status'] ?? 'PENDING',
      message: json['message'],
      bio: json['bio'],
      professionalBackground: json['professionalBackground'],
      preferredRegions: parsedRegions,
      availableCapital: json['availableCapital'] != null
          ? (json['availableCapital'] as num).toDouble()
          : null,
      financingNeeded: json['financingNeeded'],
      ndaAccepted: json['ndaAccepted'],
      cvKey: json['cvKey'],
      estadoAnalisis: json['estadoAnalisis'],
      resultadoIa: parsedIa,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'owner': owner.toJson(),
      'interestedUser': interestedUser.toJson(),
      'opportunity': opportunity.toJson(),
      'status': status,
      'message': message,
      'bio': bio,
      'professionalBackground': professionalBackground,
      'preferredRegions': preferredRegions,
      'availableCapital': availableCapital,
      'financingNeeded': financingNeeded,
      'ndaAccepted': ndaAccepted,
      'cvKey': cvKey,
      'estadoAnalisis': estadoAnalisis,
      'resultadoIa': resultadoIa?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
