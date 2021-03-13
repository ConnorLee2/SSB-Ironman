class Fighter {
  int id;
  String name;
  String series;

  Fighter(this.id, this.name, this.series);

  Fighter.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        series = json['series'];

  String getImgName() {
    var s = name.replaceAll(new RegExp(r'(?:_|[^\w\s])+'), '');
    s = s.replaceAll(' ', '_');
    s = s.replaceAll('__', '_');
    s = s.toLowerCase();
    var imgName = 'assets/characters/$s.png';
    return imgName;
  }

  String getBackgroundString() {
    if (series == 'Metal Gear') {
      return 'assets/background/MetalGearSymbol.png';
    } else if (series == 'Persona') {
      return 'assets/background/PersonaSymbol.png';
    } else {
      String prefix = 'assets/background/';
      var s = series.replaceAll(new RegExp(r'(?:_|[^\w\s])+'), '');
      s = s.replaceAll(' ', '');
      String postfix = 'Symbol.svg';
      String backgroundString = '$prefix$s$postfix';
      print(backgroundString);

      return backgroundString;
    }
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Fighter && other.id == id;
}
