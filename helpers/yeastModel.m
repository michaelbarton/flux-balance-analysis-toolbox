function model = yeastModel()

  model = readCbModel('models/Sc_iND750_GlcMM.xml');

  % Block malate, oxoglutarate, and alpha-ketoglutarate entry into model
  model = changeRxnBounds(model, 'AKGMAL', 0, 'u');
  model = changeRxnBounds(model, 'AKGt2r', 0, 'u');
  model = changeRxnBounds(model, 'MALt2r', 0, 'b');
