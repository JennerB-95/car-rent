import 'dart:typed_data';

import 'package:car_rental/models/my_booking.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makePdf(MisReservas reserva) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/welcome/logotipo.jpg'))
          .buffer
          .asUint8List());
  pdf.addPage(
    MultiPage(
      pageFormat: PdfPageFormat.standard,
      build: (context) {
        return <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Wrap(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: Image(imageLogo),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text("Contrato No.", textAlign: TextAlign.center),
                    Container(
                        width: 75.0,
                        margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: PdfColor.fromInt(0xff000000)))),
                        child: Text(reserva.id, textAlign: TextAlign.center))
                  ]),
                  Row(children: [
                    Text("Reservación No."),
                    Container(
                        width: 75.0,
                        margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: PdfColor.fromInt(0xff000000)))),
                        child: Text(reserva.id, textAlign: TextAlign.center))
                  ]),
                ])
              ]),
              Text(
                  "Conste por el presente documento el contrato de ALQUILER del vehículo de Placa Nº que celebran de una parte el Sr(a) ${reserva.name} identificado con el número de DPI _______________, quien señala lugar para recibir notificaciones y citaciones la dirección descrita que para los efectos del presente contrato se le denominará EL ARRENDATARIO, sujeto a los términos y condiciones siguientes:",
                  textScaleFactor: 0.9,
                  textAlign: TextAlign.justify),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                    '1. ZEUS SOCIEDAD ANONIMA, Es una entidad jurídica que en el presente Contrato Mercantil se denomina el ARRENDANTE, da en arrendamiento el vehiculó descrito, a las personas individuales o jurídicas, cuyo nombre, denominación o razón social aparece en el presente contrato y a quien se denominara el ARRENDATARIO ',
                    textAlign: TextAlign.justify,
                    textScaleFactor: 0.74,
                    style: TextStyle(fontSize: 12.0)),
              ),
              Text(
                  '2. EL ARRRENDATARIO a) Recibe el vehículo en perfectas condiciones de funcionamiento mecánico, cerraduras, pintura, accesorios, neumático de repuesto, kit de herramientas y la documentación necesaria para su circulación, b) En el caso de vehículos refrigerados el equipo de refrigeración se entrega en perfecto estado de funcionamiento, provisto de su control y medidor de temperatura. C) Firmara una hoja de chequeo y se le entregará una copia como constancia de recibir el vehículo a su entera satisfacción, misma que le servirá de base en la devolución.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '3. REQUISITOS PARA ARRENDAR VEHICULOS: a) Solo las personas autorizadas en el presente contrato serán las que manejen el vehículo, con la condición de que hayan cumplido 25 años y sean titulares de Licencia de Conducir Vigente, b) Cancelar el importe total del alquiler antes de la salida, mediante dinero en efectivo o tarjeta de crédito; c) Dejar un depósito para garantizar el buen uso y correcta devolución del vehículo.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '4. UTILIZACION DEL VEHICULO: El vehículo objeto de este contrato se destinará única y exclusivamente para el trasporte del Arrendatario y sus acompañantes: Deberá utilizarlo con la debida diligencia y de conformidad con las características del mismo, y en caso, de que haga acompañar de niños menores de 5 años, el Arrendatario deberá proveerse de silla adecuada y bajo su total responsabilidad.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '5. ENTREGA Y DEVOLUCION: EL ARRENDATARIO Se compromete a devolver el vehículo al vencimiento del plazo en las mismas condiciones en que lo recibe según hoja de chequeo. Se entenderá que el vehículo en alquiler ha sido debidamente devuelto por el Arrendatario, si se produce en las instalaciones de la entidad Arrendante o en cualquiera de sus sucursales, en las condiciones que le fue dado y dentro del plazo convenido, bajo las mismas condiciones de limpieza e higiene que le fue entregado, con su interior limpio y libre de mal olor o cigarrillo u otras substancias; queda totalmente prohibido fumar dentro de los mismos. En el caso que no fuese entregado bajo estas condiciones de higiene, el Arrendante cobrara por la limpieza para regresarlo al estado en que le fue entregado. Tanto en la entrega como en la devolución se hará constar en los documentos anexos del contrato, cualquier daño nuevo que se haya producido durante el uso del vehiculó, por menor que este sea, así como la falta de cualquiera de los accesorios y herramientas será cargado en la cuenta del Arrendatario. Así mismo se establece que los retrasos en la devolución, que no hayan sido autorizadas por el Arrendante, ni debido a motivos de fuerza mayor, serán penalizados con una tarifa diaria al doble de la cantidad aplicada en el contrario y después de 24 horas sin tener constancia expresa de los motivos que justifiquen la demora en la devolución, el Arrendante entenderá que existe el delito APROPIACION Y RETENCIÓN INDEBIDA del vehículo, procediendo a realizar inmediatamente la denuncia ante las autoridades competentes. Las costas de los Profesionales del Derecho en los que se auxilie el Arrendante, y cualquier otro gasto que se genere en la recuperación del vehículo, serán pagados en su totalidad por el Arrendatario. Además, pagara una indemnización que el arrendante determinara de acuerdo a las condiciones en que se recuperé el vehiculó y faculta al Arrendante para que pueda recuperar el vehículo objeto del presente contrato en el lugar donde se encuentre, sin previa autorización judicial y bajo la total responsabilidad del Arrendatario por cualquier acto ilícito que se haya cometido con el vehiculó en alquiler.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '6. PLAZO DEL CONTRATO Y PRORROGA: El periodo del alquiler se indica en el este contrato, estableciéndose la fecha y hora de salida y devolución. Cada día de renta será sobre la base de 24 horas. En caso que el Arrendatario realice la devolución del vehículo con antelación a su vencimiento o finalización del plazo del contrato, no obliga al Arrendante a la devolución o deducción al importe total pagado. En caso que el Arrendatario quiera prorrogar el plazo establecido en el contrato deberá comunicarlo al Arrendante con un tiempo de anticipación a la finalización del contrato, entendiendo que la comunicación será de medio día por cada día que se haya contratado. La eventual confirmación de la prórroga de alquiler estará sujeta a las disponibilidades que en ese momento tenga el ARRENDANTE, no asumiendo por tanto este último compromiso previo alguno. La duración del contrato y sus prorrogas nunca excederán de 1 mes, salvo nueva suscripción de contrato.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '7. OBLIGACIONES Y PROHIBICIONES DEL ARRENDATARIO: El Arrendatario está obligado a cumplir las siguientes condiciones: a) Únicamente el arrendatario y las personas o conductores autorizados en el presente contrato, pueden utilizar o conducir el vehículo en alquiler; b) El arrendatario será responsable en todo momento del buen uso que se le dé vehículo en alquiler y se destinara solamente para los fines a los que está destinado; c) Obedecer y cumplir las leyes vigentes del país, especialmente las que se refieran a las Leyes de Tránsito de Vehículos. Serán por cuenta del Arrendatario las multas o infracciones que se deriven de la violación de las mismas; d) Está obligado a cuidar y mantener en buen estado el vehículo, a revisar constantemente niveles de aceite en el motor, agua del radiador y presión de llantas; e) Una vez revisado y firmado el contrato, no se podrán hacer cambios en las tarifas y otras condiciones del contrato; f) Asumir cualquier responsabilidad ya sea penal, civil y administrativa generada por el uso del vehículo durante el periodo que dure el arrendamiento, respaldado por su contrato, inclusive el tiempo de prorroga si el cliente lo solicita; g) Informar inmediatamente a las autoridades correspondientes y al Arrendante, de cualquier accidente, robo, incendio o daño al vehículo; al incumplir con esta obligación se pierde la cobertura de seguro y el Arrendatario asume la totalidad de gasto que se generen al arrendante y ante terceras personas; h) Responder con prontitud para solicitar los daños y perjuicios ocasionados por dolo o negligencia; I) En caso del alquiler de vehículos refrigerados, el Arrendatario al transportar su mercadería lo hace bajo su propio riesgo de conservación.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(imageLogo),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text("Contrato No."),
                    Container(
                        width: 75.0,
                        margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: PdfColor.fromInt(0xff000000)))),
                        child: Text(reserva.id, textAlign: TextAlign.center))
                  ]),
                  Row(children: [
                    Text("Reservación No."),
                    Container(
                        width: 75.0,
                        margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: PdfColor.fromInt(0xff000000)))),
                        child: Text(reserva.id, textAlign: TextAlign.center))
                  ]),
                ])
              ]),
              Text(
                  '8. ESTA PROHIBIDO: a) Manejar bajo efectos de alcohol, narcóticos, medicamentos o cualquier otra sustancia legal o ilegal que afecte su capacidad de conducir y autoriza expresamente al Arrendante para que pueda realizar pruebas de alcoholemia o drogadicción en caso necesario, si el resultado fuese positivo el Arrendatario responderá totalmente por los daños causados al Arrendante y terceros. Si el Arrendatario o el responsable de los daños se negaran a realizarse los exámenes de alcoholemia, se tomara como una violación al contrato y como resultado positivo. b) Destinar el vehículo a cualquier actividad contraria a la moral, las leyes y las buenas costumbres. C) Usar el vehículo en forma lucrativa, ya sea trasportando personas o artículos en caso de vehículos no comerciales; d) Salir con el vehículo fuera de los límites de la jurisdicción de la República de Guatemala salvo autorización expresa y escrita del Arrendante, y si el vehículo fuera sacado de la República de Guatemala sin autorización del Arrendante, lo interpretara como ROBO del mismo y se procederá a realizar inmediatamente la denuncia ante las autoridades competentes, las costas de los profesionales del Derecho que se auxilie el Arrendante y cualquier gasto adicional que se generen a raíz de la referida denuncia, se cobraran al Arrendatario y este pagara una indemnización equivalente al 100% del valor del vehículo; e) Conducir a velocidades mayores a los límites establecidos en el territorio en el que circule; f) Utilizar el vehículo para arrastrar algún remolque o para empujar otro vehículo, a menos que exista autorizaron expresa y escrita del Arrendante; g) Efectuar reparación o modificación alguna en el vehículo, salvo que contara con la autorización expresa de la parte del Arrendante. Caso contrario se cobrara nuevamente la reparación; h) Ser autor o cómplice de cualquier acto ilícito llevado a cabo con el vehículo; l) Sub-arrendar el vehículo, ceder los derechos a terceras personas ajenas al contrato, dar en garantía o pignorar el vehículo, sus accesorios, llaves o documentación; j) Utilizar el vehículo para el trasporte de sustancias toxicas, corrosivas, nocivas o explosivas; k) Transportar ilegalmente personas, drogas, contrabando o cualquier otro uso contario a las leyes del país; l) Conducir en lugares donde se esté gestando o llevando a cabo una manifestación, huelga, motín, redada, o cualquier agrupación o asociación de personas que pueda degenerar en escándalos o daños a terceros en la vía púbica; m) Conducir en lugares notoriamente peligrosos, que sean calificados por las autoridades como zonas rojas de peligro, la conducción del vehículo para pruebas de defensa personal o persecución; o) Permitir que conduzca el vehículo personas NO autorizadas en el presente contrato; en tal caso, el Arrendatario se hace totalmente responsable de cualquier daño que ocasione esta persona; p) Sobrecargar el vehículo con relación a su resistencia y capacidad, o transportar un mayor número de personas que el permitido según la capacidad del vehículo indicado en la tarjeta de circulación, o colocar equipaje encima del vehículo, y cualquier actividad que menoscabe las condiciones del mismo y que contrarié su destino. En caso que el arrendatario no cumpla con las causales enunciadas en el presente apartado, queda advertido que no tendrá cobertura del Seguro y cancelara la totalidad de los daños y gastos incurridos derivados de su incumpliendo.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '9. PRECIOS, COBROS Y DEPÓSITO. a) Del Precio: Es el expresado en este contrato de acuerdo a la tarifa contratada, y que el Arrendatario está de acuerdo y acepta. Se facturara en base a periodos de 24 hrs, contados desde la hora en que se formaliza el contrato de alquiler, y el arrendatario se obliga a pagar las cantidades correspondientes a la duración del alquiler; b) De los cobros: El cobro de la renta se hará por medio de tarjeta de crédito o en efectivo. En caso de rentas a clientes que tengan autorizado crédito, si al vencimiento del plazo de la factura el cliente realiza el pago con tarjeta de crédito se hará un recargo del 8%. En caso de daños causados al vehículo por accidente o pérdida total, cuanto dichos daños o perdida ya no estén cubiertos por el Seguro o estén debajo del valor de deducible, el Arrendatario se obliga a pagarlos de acuerdo a una cotización del Arrendante o de la agencia distribuidora de la marca del automóvil. El Arrendatario será el responsable de pagar todos los gastos incurridos en la reparación total o parcial por los daños causados al vehículo, ya sea por el uso indebido o del cuidado inadecuado o negligente del vehículo incluyendo traslados y la paralización del mismo, y pagara cualquier gasto judicial o extrajudicial, que se genere por la recuperación del mismo; además cancelara los cargos por la pérdida de los accesorios o documentos del vehículo incluyendo multas por cualquier infracción a las leyes del país, especialmente las relativas a las Leyes de Tránsito y que corresponden al vehículo durante la vigencia de este contrato.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '10. SEGUROS: El vehículo en alquiler cuenta con un seguro amparado por una póliza de flota emitida por una compañía de seguros reconocida y cubre Responsabilidad Civil, Daños a Terceros, Gastos Médicos, asesoría Legal y en caso de los daños propios el vehículo arrendado se maneja en base a deducibles de acuerdo al valor asignado en el adverso de este contrato en la casilla que dice Deducibles, el seguro es válido siempre y cuando se cumpla con los términos del presente contrato y con los requerimientos de la póliza de seguros. Para que el seguro surta sus efectos de cobertura, se deben cumplir con las siguientes condiciones: Únicamente el Arrendatario y los conductores autorizados en este contrato pueden conducir el vehículo, en caso de inobservancia de esta disposición o de cualquiera de las contenidas dentro del presente contrato, además de las contenidas en la póliza de seguros da lugar a la perdida de cobertura del seguro; En caso que sea denegada la cobertura de seguro por parte del Arrendante o de la Compañía de Seguros, por los daños y perjuicios al vehículo arrendado, así como a terceras personas, vehículos o bienes inmuebles, todos los daños serán pagados por el Arrendatario. El Arrendatario se obliga durante la vigencia del presente contrato, a informar inmediatamente a las autoridades correspondientes y al Arrendante, de cualquier accidente, robo, incendio o daño corporal, en caso de no hacerlo, el seguro denegara la cobertura de conformidad con las exclusiones de la póliza de seguros y el Arrendatario responderá jurídicamente y pagara en su totalidad todos los gastos ocasionados a terceras personas, bienes muebles o inmuebles, derivados del accidente y valor del vehículo si se determina la destrucción total del mismo, así como la indemnización a personas afectadas ya sea de sus acompañantes o terceros, los gastos y costas judiciales tendrán que ser cancelados por el Arrendatario. Si el Arrendatario cumple con lo estipulado en este contrato, el seguro los daños ocasionados en el lugar del accidente, pero no cubre los posteriores al accidente, como seguir conduciendo el vehículo estando chocado y esto provoque daños en otras partes internas o externas del vehículo o daños a terceros. DEDUCIBLE: Los deducibles especificados en el adverso de este contrato, son la garantía del vehículo en alquiler y son los valores máximos que pagara el Arrendatario en caso de accidente, robo o destrucción total, siempre que haya cumplido con las cláusulas y condiciones del presente contrato y las estipuladas en la póliza de seguro. TARJETA DE CREDITO: El ARRENDATARIO desde ahora autoriza para que pueda ser cobrado de su tarjeta de crédito dejada como garantía, daños no cubiertos por el seguro, en los casos de accidente no causados por el Arrendatario, el Arrendante solamente asesora al Arrendatario, calculándole el costo de los daños para que el tercero que ocasiono el accidente los cancele al Arrendatario. En caso que el tercero no se responsabilice y no cancele los daños al Arrendatario, entonces, esta queda obligado a cancelarlos siendo el valor máximo a pagar el deducible por accidente o destrucción total, según sea el caso.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(imageLogo),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text("Contrato No.", textAlign: TextAlign.center),
                    Container(
                        width: 75.0,
                        margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: PdfColor.fromInt(0xff000000)))),
                        child: Text(reserva.id, textAlign: TextAlign.center))
                  ]),
                  Row(children: [
                    Text("Reservación No."),
                    Container(
                        width: 75.0,
                        margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: PdfColor.fromInt(0xff000000)))),
                        child: Text(reserva.id, textAlign: TextAlign.center))
                  ]),
                ])
              ]),
              Text(
                  '11. IMCUMPLIMIENTO DEL CONTRATO: El incumplimiento de cualquiera de las obligaciones contraídas en este contrato por parte del Arrendatario, da derecho al Arrendante para dar por terminado el plazo del presente contrato y a exigir la inmediata devolución del vehículo y el Arrendatario renuncia al fuero de su domicilio y se somete a los Tribunales de la ciudad de Quetzaltenango y acepta como buenas y exactas las cuentas que la Arrendante presente con respecto de este contrato y las obligaciones que hoy contraen y las reconoce sobre la presente fecha como liquidas, exigibles y de plazo vencido, los saldos que le presenten para su cobro extrajudicial o judicial y expresa que para el cobro del mismo, señala como lugar para recibir notificaciones, citaciones y/o emplazamiento la dirección que se consigne en el contrato y se tendrá como bien hechas las que allí se realicen. Asimismo, el Arrendatario, por cualquier incumplimiento a las condiciones u obligaciones pactadas en el presente contrato, exime de toda responsabilidad al Arrendante y la contenida en el artículo 1651 del Código Civil y asume todas las responsabilidades legales que se le puedan aducir.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '12. LUCRO ESANTE: Es la indemnización que el Arrendatario pagara, debido a la inmovilización del vehículo, ya sea por reparación de daños o por haber detenido el vehículo por cualquier autoridad competente hasta que se recupere el mismo por parte del Arrendante o por cualquier otra situación por la cual se paralice el vehículo, causa imputables al Arrendatario. La indemnización por Lucro Cesante se calculara tomando la base la renta diaria mencionada en el adverso del presente contrato multiplicado por el número de días que sea necesario invertir en la reparación o recuperación del vehículo, hasta que el mismo este en poder del arrendante y en condiciones óptimas de seguirlo rentando.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '13. OBJETOS OLVIDADOS: El Arrendante no será responsable por el olvido, perdida o daño de cualquier objeto o valor que el Arrendatario o sus acompañantes, dejen, almacenen o transporten en el vehículo en alquiler, ya sea antes o después de la entrega o devolución del mismo.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '14. LEGISLACION Y JURISDICCION APLICABLES: Para toda controversia derivada de la aplicación del presente contrato, ambas partes acuerdan someter las diferencias y el cumplimiento de este contrato a los Tribunales de Justicia de la Jurisdicción de Quetzaltenango.',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              Text(
                  '15. GASTOS NO PREVISTOS: cualquier otro gasto que se genere sin la responsabilidad del arrendante y que no cubra el seguro serán gastos exclusivos del arrendatario, si el vehículo es robado y recuperado, los daños que se ocasionen serán responsabilidad del arrendatario. ',
                  textAlign: TextAlign.justify,
                  textScaleFactor: 0.74,
                  style: TextStyle(fontSize: 12.0)),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                    'ACEPTACION DE LAS CONDICIONES DEL CONTRATO: Yo, el Arrendatario, declaro: Que la información que he suministrado es verídica y autorizo expresa e irrevocablemente a ZEUS SOCIEDAD ANONIMA o a quien en el futuro sea mi acreedor o contra parte contractual para: a) Corroborarla por cualquier medio legal, por la persona, entidad o empresa que designe; b) Consultar en cualquier momento, información de la centrales o Buros de riesgo que considere pertinente; c) Reportar a las Centrales de Riesgo o Buros de Crédito la información menciona en el numeral anterior, con el fin de que estas puedan tratarla, analizarla, clasificarla, conservarla y suministrarla para generar historial de Crédito. Asimismo, declaro que LEO LO ESCRITO, QUE BIEN ENTERADO DE SU CONTENIDO, OBJETO, VALIDEZ Y DEMAS EFECTOS LEGALES, LO ACETPO, RATIFICO Y FIRMO.',
                    textAlign: TextAlign.justify,
                    textScaleFactor: 0.74,
                    style: TextStyle(fontSize: 12.0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 70.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(children: [
                    Container(
                      width: 150.0,
                      margin: EdgeInsets.only(top: 25.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: PdfColor.fromInt(0xff000000)))),
                    ),
                    Text("Arrendatario"),
                  ]),
                  SizedBox(width: 15.0),
                  Column(children: [
                    Container(
                      width: 150.0,
                      margin: EdgeInsets.only(top: 25.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: PdfColor.fromInt(0xff000000)))),
                    ),
                    Text("Conductor Adicional"),
                  ]),
                  SizedBox(width: 15.0),
                  Column(children: [
                    Container(
                      width: 150.0,
                      margin: EdgeInsets.only(top: 25.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: PdfColor.fromInt(0xff000000)))),
                    ),
                    Text("Conductor Adicional"),
                  ]),
                ]),
              ),
            ]),
          ),
        ];
      },
    ),
  );
  return pdf.save();
}

Widget Contrato() {
  return Text(
      "Conste por el presente documento el contrato de ALQUILER del vehículo de Placa Nº que celebran de una parte el Sr(a)._______________________________________ identificado con el número de DPI _______________, quien señala lugar para recibir notificaciones y citaciones la dirección descrita que para los efectos del presente contrato se le denominará EL ARRENDATARIO, sujeto a los términos y condiciones siguientes: 1.ZEUS SOCIEDAD ANONIMA, Es una entidad jurídica que en el presente Contrato Mercantil se denomina el “ARRENDANTE”, da en arrendamiento el vehiculó descrito, a las personas individuales o jurídicas, cuyo nombre, denominación o razón social aparece en el presente contrato y a quien se denominara el “ARRENDATARIO” 2.“EL ARRRENDATARIO” a) Recibe el vehículo en perfectas condiciones de funcionamiento mecánico, cerraduras, pintura, accesorios, neumático de repuesto, kit de herramientas y la documentación necesaria para su circulación, b) En el caso de vehículos refrigerados el equipo de refrigeración se entrega en perfecto estado de funcionamiento, provisto de su control y medidor de temperatura. C) Firmara una hoja de chequeo y se le entregará una copia como constancia de recibir el vehículo a su entera satisfacción, misma que le servirá de base en la devolución. 3.REQUISITOS PARA ARRENDAR VEHICULOS: a) Solo las personas autorizadas en el presente contrato serán las que manejen el vehículo, con la condición de que hayan cumplido 25 años y sean titulares de Licencia de Conducir Vigente, b) Cancelar el importe total del alquiler antes de la salida, mediante dinero en efectivo o tarjeta de crédito; c) Dejar un depósito para garantizar el buen uso y correcta devolución del vehículo. 4.UTILIZACION DEL VEHICULO: El vehiculó objeto de este contrato se destinará única y exclusivamente para el trasporte del “Arrendatario” y sus acompañantes: Deberá utilizarlo con la debida diligencia y de conformidad con las características del mismo, y en caso, de que haga acompañar de niños menores de 5 años, el “Arrendatario” deberá proveerse de silla adecuada y bajo su total responsabilidad. 5.ENTREGA Y DEVOLUCION: “EL ARRENDATARIO” Se compromete a devolver el vehículo al vencimiento del plazo en las mismas condiciones en que lo recibe según hoja de chequeo. Se entenderá que el vehículo en alquiler ha sido debidamente devuelto por el “Arrendatario”, si se produce en las instalaciones de la entidad “Arrendante” o en cualquiera de sus sucursales, en las condiciones que le fue dado y dentro del plazo convenido, bajo las mismas condiciones de limpieza e higiene que le fue entregado, con su interior limpio y libre de mal olor o cigarrillo u otras substancias; queda totalmente prohibido fumar dentro de los mismos. En el caso que no fuese entregado bajo estas condiciones de higiene, el “Arrendante” cobrara por la limpieza para regresarlo al estado en que le fue entregado. Tanto en la entrega como en la devolución se hará constar en los documentos anexos del contrato, cualquier daño nuevo que se haya producido durante el uso del vehiculó, por menor que este sea, así como la falta de cualquiera de los accesorios y herramientas será cargado en la cuenta del “Arrendatario”. Así mismo se establece que los retrasos en la devolución, que no hayan sido autorizadas por el “Arrendante”, ni debido a motivos de fuerza mayor, serán penalizados con una tarifa diaria al doble de la cantidad aplicada en el contrario y después de 24 horas sin tener constancia expresa de los motivos que justifiquen la demora en la devolución, el “Arrendante” entenderá que existe el delito APROPIACION Y RETENCIÓN INDEBIDA del vehículo, procediendo a realizar inmediatamente la denuncia ante las autoridades competentes. Las costas de los Profesionales del Derecho en los que se auxilie el “Arrendante”, y cualquier otro gasto que se genere en la recuperación del vehiculó, serán pagados en su totalidad por el “Arrendatario”. Además, pagara una indemnización que el “arrendante” determinara de acuerdo a las condiciones en que se recuperé el vehiculó y faculta al “Arrendante” para que pueda recuperar el vehículo objeto del presente contrato en el lugar donde se encuentre, sin previa autorización judicial y bajo la total responsabilidad del “Arrendatario” por cualquier acto ilícito que se haya cometido con el vehiculó en alquiler. 6.PLAZO DEL CONTRATO Y PRORROGA: El periodo del alquiler se indica en el este contrato, estableciéndose la fecha y hora de salida y devolución. Cada día de renta será sobre la base de 24 horas. En caso que el “Arrendatario” realice la devolución del vehículo con antelación a su vencimiento o finalización del plazo del contrato, no obliga al “Arrendante” a la devolución o deducción al importe total pagado. En caso que el “Arrendatario” quiera prorrogar el plazo establecido en el contrato deberá comunicarlo al “Arrendante” con un tiempo de anticipación a la finalización del contrato, entendiendo que la comunicación será de medio día por cada día que se haya contratado. La eventual confirmación de la prórroga de alquiler estará sujeta a las disponibilidades que en ese momento tenga el “ARRENDANTE”, no asumiendo por tanto este último compromiso previo alguno. La duración del contrato y sus prorrogas nunca excederán de 1 mes, salvo nueva suscripción de contrato. 7.OBLIGACIONES Y PROHIBICIONES DEL ARRENDATARIO: El “Arrendatario” está obligado a cumplir las siguientes condiciones: a) Únicamente el “arrendatario” y las personas o conductores autorizados en el presente contrato, pueden utilizar o conducir el vehículo en alquiler; b) El “arrendatario” será responsable en todo momento del buen uso que se le dé vehículo en alquiler y se destinara solamente para los fines a los que está destinado; c) Obedecer y cumplir las leyes vigentes del país, especialmente las que se refieran a las Leyes de Tránsito de Vehículos. Serán por cuenta del “Arrendatario” las multas o infracciones que se deriven de la violación de las mismas; d) Está obligado a cuidar y mantener en buen estado el vehículo, a revisar constantemente niveles de aceite en el motor, agua del radiador y presión de llantas; e) Una vez revisado y firmado el contrato, no se podrán hacer cambios en las tarifas y otras condiciones del contrato; f) Asumir cualquier responsabilidad ya sea penal, civil y administrativa generada por el uso del vehículo durante el periodo que dure el arrendamiento, respaldado por su contrato, inclusive el tiempo de prorroga si el cliente lo solicita; g) Informar inmediatamente a las autoridades correspondientes y al “Arrendante”, de cualquier accidente, robo, incendio o daño al vehículo; al incumplir con esta obligación se pierde la cobertura de seguro y el “Arrendatario” asume la totalidad de gasto que se generen al “arrendante” y ante terceras personas; h) Responder con prontitud para solicitar los daños y perjuicios ocasionados por dolo o negligencia; I) En caso del alquiler de vehículos refrigerados, el “Arrendatario” al transportar su mercadería lo hace bajo su propio riesgo de conservación.8.ESTA PROHIBIDO: a) Manejar bajo efectos de alcohol, narcóticos, medicamentos o cualquier otra sustancia legal o ilegal que afecte su capacidad de conducir y autoriza expresamente al “Arrendante” para que pueda realizar pruebas de alcoholemia o drogadicción en caso necesario, si el resultado fuese positivo el “Arrendatario” responderá totalmente por los daños causados al “Arrendante” y terceros. Si el “Arrendatario” o el responsable de los daños se negaran a realizarse los exámenes de alcoholemia, se tomara como una violación al contrato y como resultado positivo. b) Destinar el vehículo a cualquier actividad contraria a la moral, las leyes y las buenas costumbres. C) Usar el vehículo en forma lucrativa, ya sea trasportando personas o artículos en caso de vehículos no comerciales; d) Salir con el vehículo fuera de los límites de la jurisdicción de la República de Guatemala salvo autorización expresa y escrita del “Arrendante”, y si el vehículo fuera sacado de la República de Guatemala sin autorización del “Arrendante”, lo interpretara como ROBO del mismo y se procederá a realizar inmediatamente la denuncia ante las autoridades competentes, las costas de los profesionales del Derecho que se auxilie el “Arrendante” y cualquier gasto adicional que se generen a raíz de la referida denuncia, se cobraran al “Arrendatario” y este pagara una indemnización equivalente al 100% del valor del vehículo; e) Conducir a velocidades mayores a los límites establecidos en el territorio en el que circule; f) Utilizar el vehículo para arrastrar algún remolque o para empujar otro vehículo, a menos que exista autorizaron expresa y escrita del “Arrendante”; g) Efectuar reparación o modificación alguna en el vehículo, salvo que contara con la autorización expresa de la parte del “Arrendante”. Caso contrario se cobrara nuevamente la reparación; h) Ser autor o cómplice de cualquier acto ilícito llevado a cabo con el vehículo; l) Sub-arrendar el vehículo, ceder los derechos a terceras personas ajenas al contrato, dar en garantía o pignorar el vehículo, sus accesorios, llaves o documentación; j) Utilizar el vehículo para el trasporte de sustancias toxicas, corrosivas, nocivas o explosivas; k) Transportar ilegalmente personas, drogas, contrabando o cualquier otro uso contario a las leyes del país; l) Conducir en lugares donde se esté gestando o llevando a cabo una manifestación, huelga, motín, redada, o cualquier agrupación o asociación de personas que pueda degenerar en escándalos o daños a terceros en la vía púbica; m) Conducir en lugares notoriamente peligrosos, que sean calificados por las autoridades como zonas rojas de peligro, la conducción del vehículo para pruebas de defensa personal o persecución; o) Permitir que conduzca el vehículo personas NO autorizadas en el presente contrato; en tal caso, el “Arrendatario” se hace totalmente responsable de cualquier daño que ocasione esta persona; p) Sobrecargar el vehículo con relación a su resistencia y capacidad, o transportar un mayor número de personas que el permitido según la capacidad del vehículo indicado en la tarjeta de circulación, o colocar equipaje encima del vehículo, y cualquier actividad que menoscabe las condiciones del mismo y que contrarié su destino. En caso que el “arrendatario” no cumpla con las causales enunciadas en el presente apartado, queda advertido que no tendrá cobertura del Seguro y cancelara la totalidad de los daños y gastos incurridos derivados de su incumpliendo. 9.PRECIOS, COBROS Y DEPÓSITO. a) Del Precio: Es el expresado en este contrato de acuerdo a la tarifa contratada, y que el “Arrendatario” está de acuerdo y acepta. Se facturara en base a periodos de 24 hrs, contados desde la hora en que se formaliza el contrato de alquiler, y el “arrendatario” se obliga a pagar las cantidades correspondientes a la duración del alquiler; b) De los cobros: El cobro de la renta se hará por medio de tarjeta de crédito o en efectivo. En caso de rentas a clientes que tengan autorizado crédito, si al vencimiento del plazo de la factura el cliente realiza el pago con tarjeta de crédito se hará un recargo del 8%. En caso de daños causados al vehículo por accidente o pérdida total, cuanto dichos daños o perdida ya no estén cubiertos por el Seguro o estén debajo del valor de deducible, el “Arrendatario” se obliga a pagarlos de acuerdo a una cotización del “Arrendante” o de la agencia distribuidora de la marca del automóvil. El “Arrendatario” será el responsable de pagar todos los gastos incurridos en la reparación total o parcial por los daños causados al vehículo, ya sea por el uso indebido o del cuidado inadecuado o negligente del vehículo incluyendo traslados y la paralización del mismo, y pagara cualquier gasto judicial o extrajudicial, que se genere por la recuperación del mismo; además cancelara los cargos por la pérdida de los accesorios o documentos del vehículo incluyendo multas por cualquier infracción a las leyes del país, especialmente las relativas a las Leyes de Tránsito y que corresponden al vehículo durante la vigencia de este contrato. 10.SEGUROS: El vehículo en alquiler cuenta con un seguro amparado por una póliza de flota emitida por una compañía de seguros reconocida y cubre Responsabilidad Civil, Daños a Terceros, Gastos Médicos, asesoría Legal y en caso de los daños propios el vehículo arrendado se maneja en base a deducibles de acuerdo al valor asignado en el adverso de este contrato en la casilla que dice Deducibles, el seguro es válido siempre y cuando se cumpla con los términos del presente contrato y con los requerimientos de la póliza de seguros. Para que el seguro surta sus efectos de cobertura, se deben cumplir con las siguientes condiciones: Únicamente el “Arrendatario” y los conductores autorizados en este contrato pueden conducir el vehículo, en caso de inobservancia de esta disposición o de cualquiera de las contenidas dentro del presente contrato, además de las contenidas en la póliza de seguros da lugar a la perdida de cobertura del seguro; En caso que sea denegada la cobertura de seguro por parte del Arrendante o de la Compañía de Seguros, por los daños y perjuicios al vehículo arrendado, así como a terceras personas, vehículos o bienes inmuebles, todos los daños serán pagados por el Arrendatario. El “Arrendatario” se obliga durante la vigencia del presente contrato, a informar inmediatamente a las autoridades correspondientes y al “Arrendante”, de cualquier accidente, robo, incendio o daño corporal, en caso de no hacerlo, el seguro denegara la cobertura de conformidad con las exclusiones de la póliza de seguros y el “Arrendatario” responderá jurídicamente y pagara en su totalidad todos los gastos ocasionados a terceras personas, bienes muebles o inmuebles, derivados del accidente y valor del vehículo si se determina la destrucción total del mismo, así como la indemnización a personas afectadas ya sea de sus acompañantes o terceros, los gastos y costas judiciales tendrán que ser cancelados por el “Arrendatario”. Si el “Arrendatario cumple con lo estipulado en este contrato, el seguro los daños ocasionados en el lugar del accidente, pero no cubre los posteriores al accidente, como seguir conduciendo el vehículo estando chocado y esto provoque daños en otras partes internas o externas del vehículo o daños a terceros. DEDUCIBLE: Los deducibles especificados en el adverso de este contrato, son la garantía del vehículo en alquiler y son los valores máximos que pagara el “Arrendatario” en caso de accidente, robo o destrucción total, siempre que haya cumplido con las cláusulas y condiciones del presente contrato y las estipuladas en la póliza de seguro. TARJETA DE CREDITO: El ARRENDATARIO desde ahora autoriza para que pueda ser cobrado de su tarjeta de crédito dejada como garantía, daños no cubiertos por el seguro, en los casos de accidente no causados por el “Arrendatario”, el “Arrendante “solamente asesora al “Arrendatario”, calculándole el costo de los daños para que el tercero que ocasiono el accidente los cancele al “Arrendatario”. En caso que el tercero no se responsabilice y no cancele los daños al “Arrendatario”, entonces, esta queda obligado a cancelarlos siendo el valor máximo a pagar el deducible por accidente o destrucción total, según sea el caso. 11.IMCUMPLIMIENTO DEL CONTRATO: El incumplimiento de cualquiera de las obligaciones contraídas en este contrato por parte del “Arrendatario”, da derecho al “Arrendante” para dar por terminado el plazo del presente contrato y a exigir la inmediata devolución del vehículo y el “Arrendatario” renuncia al fuero de su domicilio y se somete a los Tribunales de la ciudad de Quetzaltenango y acepta como buenas y exactas las cuentas que la Arrendante presente con respecto de este contrato y las obligaciones que hoy contraen y las reconoce sobre la presente fecha como liquidas, exigibles y de plazo vencido, los saldos que le presenten para su cobro extrajudicial o judicial y expresa que para el cobro del mismo, señala como lugar para recibir notificaciones, citaciones y/o emplazamiento la dirección que se consigne en el contrato y se tendrá como bien hechas las que allí se realicen. Asimismo, el “Arrendatario”, por cualquier incumplimiento a las condiciones u obligaciones pactadas en el presente contrato, exime de toda responsabilidad al “Arrendante” y la contenida en el artículo 1651 del Código Civil y asume todas las responsabilidades legales que se le puedan aducir.12.LUCRO ESANTE: Es la indemnización que el “Arrendatario” pagara, debido a la inmovilización del vehículo, ya sea por reparación de daños o por haber detenido el vehículo por cualquier autoridad competente hasta que se recupere el mismo por parte del “Arrendante” o por cualquier otra situación por la cual se paralice el vehículo, causa imputables al “Arrendatario”. La indemnización por Lucro Cesante se calculara tomando la base la renta diaria mencionada en el adverso del presente contrato multiplicado por el número de días que sea necesario invertir en la reparación o recuperación del vehículo, hasta que el mismo este en poder del “arrendante” y en condiciones óptimas de seguirlo rentando. 13.OBJETOS OLVIDADOS: El “Arrendante” no será responsable por el olvido, perdida o daño de cualquier objeto o valor que el “Arrendatario” o sus acompañantes, dejen, almacenen o transporten en el vehículo en alquiler, ya sea antes o después de la entrega o devolución del mismo. 14.LEGISLACION Y JURISDICCION APLICABLES: Para toda controversia derivada de la aplicación del presente contrato, ambas partes acuerdan someter las diferencias y el cumplimiento de este contrato a los Tribunales de Justicia de la Jurisdicción de Quetzaltenango. 15.GASTOS NO PREVISTOS: cualquier otro gasto que se genere sin la responsabilidad del arrendante y que no cubra el seguro serán gastos exclusivos del arrendatario, si el vehículo es robado y recuperado, los daños que se ocasionen serán responsabilidad del arrendatario. ACEPTACION DE LAS CONDICIONES DEL CONTRATO: Yo, el “Arrendatario”, declaro: Que la información que he suministrado es verídica y autorizo expresa e irrevocablemente a ZEUS SOCIEDAD ANONIMA o a quien en el futuro sea mi acreedor o contra parte contractual para: a) Corroborarla por cualquier medio legal, por la persona, entidad o empresa que designe; b) Consultar en cualquier momento, información de la centrales o Buros de riesgo que considere pertinente; c) Reportar a las Centrales de Riesgo o Buros de Crédito la información menciona en el numeral anterior, con el fin de que estas puedan tratarla, analizarla, clasificarla, conservarla y suministrarla para generar historial de Crédito. Asimismo, declaro que LEO LO ESCRITO, QUE BIEN ENTERADO DE SU CONTENIDO, OBJETO, VALIDEZ Y DEMAS EFECTOS LEGALES, LO ACETPO, RATIFICO Y FIRMO.");
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
