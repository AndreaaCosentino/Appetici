import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'dart:math';

const int N_DOMANDE_TOTALE = 296;
const int N_DOMANDE_SOC = 76;
const int N_DOMANDE_ECO = 108;
const int N_DOMANDE_LEG = 57;
const int N_DOMANDE_ETH = 55;

enum TIPOLOGIA{
  SOC,ECO,LEG,ETH,ALL;
}
extension TIPOLOGIA_ESTENSIONE on TIPOLOGIA {

  static TIPOLOGIA convert(String tipo){
    switch (tipo) {
      case "SOC":
        return TIPOLOGIA.SOC;
      case "ECO":
        return TIPOLOGIA.ECO;
      case "LEG":
        return TIPOLOGIA.LEG;
      case 'ETH':
        return TIPOLOGIA.ETH;
      case 'ALL':
        return TIPOLOGIA.ALL;
      default:
        throw new ArgumentError("Non esiste il tipo $tipo");
    }
  }
}

Future<String> loadAsset() async {
  var path = 'assets/domandeAspetti.csv';
  final myData = await rootBundle.loadString(path);
  print(myData);
  return myData;
}

List<int> creaDomande(int N_DOMANDE, TIPOLOGIA tipo) {
  List<int> domande = [];
  List<List<dynamic>> values = const CsvToListConverter().convert(domanda);

  if( (tipo == TIPOLOGIA.SOC && N_DOMANDE > N_DOMANDE_SOC) || (tipo == TIPOLOGIA.ECO && N_DOMANDE > N_DOMANDE_ECO)
      || (tipo == TIPOLOGIA.LEG && N_DOMANDE > N_DOMANDE_LEG) || (tipo == TIPOLOGIA.ETH && N_DOMANDE > N_DOMANDE_ETH)){
    throw new ArgumentError("Non ci sono abbastanza domande ($N_DOMANDE) del tipo selezionato ($tipo)");
  }

  Random random = new Random();
  for (int i = 0; i < N_DOMANDE; i++) {
    bool vecchioNumero = true;
    while (vecchioNumero){
      int current = random.nextInt(296) + 1;
      if (!domande.contains(current) && (tipo == TIPOLOGIA.ALL || tipo == TIPOLOGIA_ESTENSIONE.convert(values[current][2]))) {
        domande.add(current);
        vecchioNumero = false;
      }
    }
  }
  return domande;
}

int setDomande(int i) {
  List<int> tutteLeDomande = creaDomande(N_DOMANDE_TOTALE,TIPOLOGIA.ALL);
  List<int> tipologie = [0, 0, 0, 0];
  List<List<dynamic>> values = const CsvToListConverter().convert(domanda);
  for (int i = 0; i < N_DOMANDE_TOTALE; i++) {
    switch (values[i + 1][2]) {
      case 'SOC':
        tipologie[0]++;
        break;
      case 'ECO':
        tipologie[1]++;
        break;
      case 'LEG':
        tipologie[2]++;
        break;
      case 'ETH':
        tipologie[3]++;
        break;
    }
  }
  return tipologie[i];
}
