import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/spacers/spacers.dart';
import '../cubit/add_collect_cubit.dart';

class AddCollectPage extends StatefulWidget {
  static const routerName = "/add";
  const AddCollectPage({Key? key}) : super(key: key);

  @override
  _AddCollectPageState createState() => _AddCollectPageState();
}

class _AddCollectPageState
    extends ModularState<AddCollectPage, AddCollectCubit> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddCollectCubit>(
      create: (context) => controller,
      child: BlocConsumer<AddCollectCubit, AddCollectState>(
        listener: (_, state) => controller.listenerState(state),
        builder: (_, state) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(context),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Tempo de coleta"),
            _buildTextFieldTimeOfCollect(
              context,
            ),
            const SpacerHeight(30),
            const Text("Coordenadas da coleta"),
            _buildTextFieldCoordinate(
              controller: controller.textEditingLatitudeController,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                controller.maskCoordinateLatitudeFormatter,
                FilteringTextInputFormatter.allow(RegExp(r"""[0-9NS°",' ]""")),
              ],
              errorText: (state) {
                if (state is AddCollectErrorCoordinateLatitudeField) {
                  return state.message;
                }
                return null;
              },
            ),
            _buildTextFieldCoordinate(
              controller: controller.textEditingLongitudeController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) async {
                _addCollect();
              },
              inputFormatters: [
                controller.maskCoordinateLongitudeFormatter,
                FilteringTextInputFormatter.allow(RegExp(r"""[0-9WE°",' ]""")),
              ],
              errorText: (state) {
                if (state is AddCollectErrorCoordinateLongitudeField) {
                  return state.message;
                }
                return null;
              },
            ),
            const SpacerHeight(40),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return BlocBuilder<AddCollectCubit, AddCollectState>(
      builder: (_, state) {
        if (state is AddCollectLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ElevatedButton(
          onPressed: _addCollect,
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(175, 40),
            primary: Colors.orange,
          ),
          child: const Text("Enviar"),
        );
      },
    );
  }

  Widget _buildTextFieldTimeOfCollect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpacerWidth(kMinInteractiveDimension),
        BlocBuilder<AddCollectCubit, AddCollectState>(builder: (_, state) {
          return _buildTextField(
            controller: controller.textEditingDurationController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              controller.maskDurationFormatter,
            ],
            readOnly: state is AddCollectLoading,
            errorText:
                state is AddCollectErrorDurationField ? state.message : null,
            suffix: BlocBuilder<AddCollectCubit, AddCollectState>(
                builder: (_, state) {
              return IconButton(
                onPressed: state is AddCollectLoading
                    ? () {}
                    : () async {
                        await controller.pickerDuration(context);
                      },
                icon: const Icon(Icons.timelapse_rounded),
              );
            }),
          );
        }),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Adicionar coleta"),
    );
  }

  Widget _buildTextFieldCoordinate({
    TextEditingController? controller,
    TextInputAction? textInputAction,
    List<TextInputFormatter> inputFormatters = const [],
    void Function(String)? onFieldSubmitted,
    String? Function(AddCollectState)? errorText,
    void Function(String)? onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SpacerWidth(kMinInteractiveDimension),
        BlocBuilder<AddCollectCubit, AddCollectState>(builder: (_, state) {
          return _buildTextField(
            controller: controller,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters,
            readOnly: state is AddCollectLoading,
            errorText: errorText == null ? null : errorText(state),
            onChanged: onChanged,
          );
        }),
        const SpacerWidth(kMinInteractiveDimension),
      ],
    );
  }

  Widget _buildTextField({
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    TextEditingController? controller,
    void Function(String)? onFieldSubmitted,
    String? errorText,
    bool readOnly = false,
    Widget? suffix,
    void Function(String)? onChanged,
  }) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        onFieldSubmitted: onFieldSubmitted,
        style: TextStyle(
          fontSize: 28,
          color: errorText != null ? Theme.of(context).errorColor : null,
        ),
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,
          errorMaxLines: 3,
          errorText: errorText,
          suffix: suffix,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _addCollect() async {
    FocusScope.of(context).unfocus();
    await controller.addCollect();
  }
}
