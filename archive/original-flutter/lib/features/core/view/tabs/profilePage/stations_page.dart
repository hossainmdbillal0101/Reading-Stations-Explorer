import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/features/core/view/tabs/home_page.dart';
import 'package:explorer/misc/buttons.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:explorer/utils/context_less.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AllStations extends ConsumerWidget {
  AllStations({Key? key}) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(allStationsProvider);
    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          title: const Text('All Stations'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) => Neumorphic(
              padding: EdgeInsets.all(20.r),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      stations[index].name,
                      style: KEltTextStyle.blackTitleText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FBC.stationsCollection.doc(stations[index].id).delete();
                    },
                    child: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Neumorphic(
                    padding: EdgeInsets.all(20.r),
                    margin: EdgeInsets.all(20.r),
                    child: SizedBox(
                      width: 340.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Add A Station",
                            style: TextStyle(
                              color: KEltColor.txt,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AppSpacerH(20.h),
                          Neumorphic(
                            style: KEltDecoration.innerShadow,
                            child: FormBuilderTextField(
                              controller: _textEditingController,
                              keyboardType: TextInputType.text,
                              name: 'password',
                              style: const TextStyle(color: KEltColor.txt),
                              decoration:
                                  KEltInputDecoration.inputDecoration.copyWith(
                                hintText: 'Station Name',
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.minLength(context, 6),
                              ]),
                            ),
                          ),
                          AppSpacerH(20.h),
                          CustomButton(
                            title: "Add Station",
                            onTap: () {
                              FBC.stationsCollection.add({
                                'name': _textEditingController.text,
                              }).then((value) {
                                _textEditingController.clear();
                                context.nav.pop();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: const HomePageSmallButton(
            icon: Icons.add,
          ),
        ),
      ),
    );
  }
}
