import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MultipleNeedleExample extends StatefulWidget {
  final SubItemList sample;
  const MultipleNeedleExample(this.sample, {Key key}) : super(key: key);

  @override
  _MultipleNeedleExampleState createState() => _MultipleNeedleExampleState(sample);
}

class _MultipleNeedleExampleState extends State<MultipleNeedleExample> {
  final SubItemList sample;
  _MultipleNeedleExampleState(this.sample);
  bool panelOpen;
  final frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(MultipleNeedleExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (context, _, model) => SafeArea(
          child: Backdrop(
            needCloseButton: false,
            panelVisible: frontPanelVisible,
            sampleListModel: model,
            frontPanelOpenPercentage: 0.28,
            toggleFrontLayer: false,
            appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
            appBarActions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 40,
                  width: 40,
                  child: IconButton(
                    icon: Image.asset(model.codeViewerIcon,
                        color: Colors.white),
                    onPressed: () {
                      launch(
                          'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/pointers/multiple_needle.dart');
                    },
                  ),
                ),
              ),
            ],
            appBarTitle: AnimatedSwitcher(
                duration: Duration(milliseconds: 1000),
                child: Text(sample.title.toString())),
            backLayer: BackPanel(sample),
            frontLayer: FrontPanel(sample),
            sideDrawer: null,
            headerClosingHeight: 350,
            titleVisibleOnPanelClosed: true,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(12), bottom: Radius.circular(0)),
          ),
        ));
  }
}

class FrontPanel extends StatefulWidget {
  final SubItemList subItemList;
  FrontPanel(this.subItemList);

  @override
  _FrontPanelState createState() => _FrontPanelState(this.subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  final SubItemList sample;
  _FrontPanelState(this.sample);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getMultipleNeedleExample(false)),
              ));
        });
  }
}

class BackPanel extends StatefulWidget {
  final SubItemList sample;

  BackPanel(this.sample);

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  final SubItemList sample;
  GlobalKey _globalKey = GlobalKey();
  _BackPanelState(this.sample);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _getSizesAndPosition();
  }

  _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    final position = renderBoxRed.localToGlobal(Offset.zero);
    double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (context, _, model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                Padding(
                  key: _globalKey,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    sample.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

SfRadialGauge getMultipleNeedleExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(showAxisLine: false,
      radiusFactor: 0.5,
      startAngle: 270,
      endAngle: 270,
      minimum: 0,
      maximum: 60,
      showFirstLabel: false,
      interval: 5, labelOffset: 10,
      minorTicksPerInterval: 5,
      axisLabelStyle: GaugeTextStyle(fontSize: 10),
      onLabelCreated: mainAxisLabelCreated,
      minorTickStyle: MinorTickStyle(
          lengthUnit: GaugeSizeUnit.factor,
          length: 0.03, thickness: 1),
      majorTickStyle: MajorTickStyle(
          lengthUnit: GaugeSizeUnit.factor,
          length: 0.1)
  ),
      RadialAxis(axisLineStyle: AxisLineStyle(thicknessUnit: GaugeSizeUnit.factor,
        thickness: 0.08, color: Color(0xFFFFCD60)
      ),
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 12, radiusFactor: 0.9,
          showFirstLabel: false,
          interval: 1, labelOffset: 10,
          axisLabelStyle: GaugeTextStyle(fontSize: isTileView ? 10 : 12),
          minorTicksPerInterval: 5,
          onLabelCreated: mainAxisLabelCreated,
          minorTickStyle: MinorTickStyle(
              lengthUnit: GaugeSizeUnit.factor,
              length: 0.05, thickness: 1),
          majorTickStyle: MajorTickStyle(
              lengthUnit: GaugeSizeUnit.factor,
              length: 0.1),
          pointers: <GaugePointer>[

            NeedlePointer(value: 8, needleLength: 0.35, needleColor: Color(0xFFF67280),
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 0, needleEndWidth: isTileView ? 3 : 5, enableAnimation: true,
                knobStyle: KnobStyle(knobRadius: 0),
                animationType: AnimationType.ease),
            NeedlePointer(value: 3, needleLength: 0.85,
               lengthUnit: GaugeSizeUnit.factor,
                needleColor: Color(0xFFF67280),
                needleStartWidth: 0,  needleEndWidth: isTileView ? 3 : 5, enableAnimation: true,
                animationType: AnimationType.ease,
                knobStyle: KnobStyle( borderColor: Color(0xFFF67280),
                    borderWidth: 0.015, color: Colors.white,
                    sizeUnit: GaugeSizeUnit.factor,
                    knobRadius: isTileView ? 0.04 : 0.05)),
          ]
      ),


    ],
  );
}

void mainAxisLabelCreated(AxisLabelCreatedArgs args) {
  if (args.text == '12') {
    args.text = '12h';
  }
}




