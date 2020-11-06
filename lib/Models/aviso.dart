class Aviso {
  int id;
  String titlo;
  String descrip;

  Aviso({
    this.id,
    this.titlo,
    this.descrip,
  });

  factory Aviso.fromMap(Map<String, dynamic> json) => new Aviso(
        id: json["id"],
        titlo: json["titlo"],
        descrip: json["descrip"],
      );
  Map<String, dynamic> toMap() => {
    "id":id,
    "titlo":titlo,
    "descrip":descrip,
  };
}
