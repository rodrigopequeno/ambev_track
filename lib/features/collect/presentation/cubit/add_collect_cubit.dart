import 'package:asuka/asuka.dart';
import 'package:bloc/bloc.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/duration_converter/duration_converter.dart';
import '../../data/models/collect_model.dart';
import '../../data/models/geographic_coordinate_model.dart';
import '../../domain/usecases/insert_new_collect.dart';
import '../../domain/usecases/validate_geographic_coordinate.dart';

part 'add_collect_state.dart';

const _maskDuration = '99h 99m 99s!';
const _maxPlaceHoldersDuration = 6;
const _maskCoordinateLatitude = r"""99° 99' 99,99"!A""";
const _maskCoordinateLongitude = r"""999° 99' 99,99"!A""";
const _textDefaultDuration = "00h 00m 00s";
const _textDefaultCoordinateLatitude = """00° 00' 00,00"N""";
const _textDefaultCoordinateLongitude = """000° 00' 00,00"E""";
const _maxPlaceHoldersCoordinateLatitude = 8;
const _maxPlaceHoldersCoordinateLongitude = 9;
const messageError = "Ocorreu um erro, tente novamente mais tarde";
const _messageInvalidDurationError = "Tempo de coleta invalido.";
const _messageInvalidDurationNotFilledError = "Preencha o tempo de coleta.";
const _messageInvalidGeographicLatitudeError =
    "Coordenadas geograficas de latitude invalida.";
const _messageInvalidGeographicLongitudeError =
    "Coordenadas geograficas de longitude invalida.";
const _messageInvalidGeographicLatitudeDegreesError =
    "O grau das coordenadas de latitude deve variar entre 0 e 90.";
const _messageInvalidGeographicLongitudeDegreesError =
    "O grau das coordenadas de longitude deve variar entre 0 e 180.";
const _messageInvalidGeographicLatitudeCardinalError =
    "Indique se é N(Norte) ou S(Sul) ao final da coordenada de latitude.";
const _messageInvalidGeographicLongitudeCardinalError =
    "Indique se é W(Oeste) ou E(Leste) ao final da coordenada de longitude.";

class AddCollectCubit extends Cubit<AddCollectState> {
  final InsertNewCollect _insertNewCollect;
  final ValidateGeographicCoordinate _validateGeographicCoordinate;
  final DurationConverter _durationConverter;

  AddCollectCubit({
    required InsertNewCollect insertNewCollect,
    required ValidateGeographicCoordinate validateGeographicCoordinate,
    required DurationConverter durationConverter,
  })  : _insertNewCollect = insertNewCollect,
        _validateGeographicCoordinate = validateGeographicCoordinate,
        _durationConverter = durationConverter,
        super(AddCollectInitial());

  TextInputFormatter get maskDurationFormatter {
    return TextInputMask(
      mask: _maskDuration,
      placeholder: "0",
      maxPlaceHolders: _maxPlaceHoldersDuration,
    );
  }

  TextInputFormatter get maskCoordinateLatitudeFormatter {
    return TextInputMask(
      mask: _maskCoordinateLatitude,
      placeholder: "0",
      maxPlaceHolders: _maxPlaceHoldersCoordinateLatitude,
    );
  }

  TextInputFormatter get maskCoordinateLongitudeFormatter {
    return TextInputMask(
      mask: _maskCoordinateLongitude,
      placeholder: "0",
      maxPlaceHolders: _maxPlaceHoldersCoordinateLongitude,
    );
  }

  TextEditingController textEditingDurationController =
      TextEditingController(text: _textDefaultDuration);
  TextEditingController textEditingLatitudeController =
      TextEditingController(text: _textDefaultCoordinateLatitude);
  TextEditingController textEditingLongitudeController =
      TextEditingController(text: _textDefaultCoordinateLongitude);

  Future<void> pickerDuration(BuildContext context) async {
    const _durationDefault = Duration(minutes: 30);
    final text = textEditingDurationController.text;
    final _durationSelected = _durationConverter.fromStringHHhMMmSSs(text);
    final initialTime = _durationSelected.fold((l) {
      return _durationDefault;
    }, (duration) {
      return duration.inMilliseconds == 0 ? _durationDefault : duration;
    });
    Duration? resultingDuration = await showDurationPicker(
      context: context,
      initialTime: initialTime,
    );
    if (resultingDuration != null) {
      textEditingDurationController.text =
          _durationConverter.toStringFormattedHHhMMmSSs(resultingDuration);
      emit(AddCollectInitial());
    }
  }

  Future<void> addCollect({DateTime? dateTime}) async {
    emit(AddCollectLoading());
    final resultDuration = _durationConverter.fromStringHHhMMmSSs(
      textEditingDurationController.text,
    );
    resultDuration.fold((l) {
      emit(AddCollectErrorDurationField(_messageInvalidDurationError));
    }, (duration) async {
      if (duration.inSeconds <= 0) {
        emit(AddCollectErrorDurationField(
            _messageInvalidDurationNotFilledError));
        return;
      }
      final resultValidate = await _validateGeographicCoordinate(
        ValidateGeographicCoordinateParams(
          latitudeText: textEditingLatitudeController.text,
          longitudeText: textEditingLongitudeController.text,
        ),
      );
      resultValidate.fold((l) {
        /// Format Error
        if (l is InvalidGeographicLatitudeFailure) {
          emit(AddCollectErrorCoordinateLatitudeField(
              _messageInvalidGeographicLatitudeError));
        } else if (l is InvalidGeographicLongitudeFailure) {
          emit(AddCollectErrorCoordinateLongitudeField(
              _messageInvalidGeographicLongitudeError));

          /// Degrees Error
        } else if (l is InvalidGeographicLatitudeDegreesFailure) {
          emit(AddCollectErrorCoordinateLatitudeField(
              _messageInvalidGeographicLatitudeDegreesError));
        } else if (l is InvalidGeographicLongitudeDegreesFailure) {
          emit(AddCollectErrorCoordinateLongitudeField(
              _messageInvalidGeographicLongitudeDegreesError));

          /// Cardinal Error
        } else if (l is InvalidGeographicCardinalLatitudeFailure) {
          emit(AddCollectErrorCoordinateLatitudeField(
              _messageInvalidGeographicLatitudeCardinalError));
        } else if (l is InvalidGeographicCardinalLongitudeFailure) {
          emit(AddCollectErrorCoordinateLongitudeField(
              _messageInvalidGeographicLongitudeCardinalError));
        }
      }, (geographicCoordinate) async {
        final latitude = geographicCoordinate.value1;
        final longitude = geographicCoordinate.value2;
        final latitudeModel = GeographicCoordinateModel(
          degrees: latitude.degrees,
          minutes: latitude.minutes,
          seconds: latitude.seconds,
          cardinalPoint: latitude.cardinalPoint,
        );
        final longitudeModel = GeographicCoordinateModel(
          degrees: longitude.degrees,
          minutes: longitude.minutes,
          seconds: longitude.seconds,
          cardinalPoint: longitude.cardinalPoint,
        );
        final newCollect = CollectModel(
          dateTime: dateTime ?? DateTime.now(),
          duration: duration,
          latitude: latitudeModel,
          longitude: longitudeModel,
        );
        final result = await _insertNewCollect(
          InsertNewCollectParams(newCollect: newCollect),
        );
        result.fold((l) {
          emit(AddCollectError(messageError));
        }, (r) {
          _cleanAllFields();
          emit(AddCollectSuccess());
        });
      });
    });
  }

  void listenerState(AddCollectState state) {
    if (state is AddCollectError) {
      AsukaSnackbar.alert(state.message).show();
    } else if (state is AddCollectSuccess) {
      AsukaSnackbar.success("Coleta adicionada com sucesso!").show();
    }
  }

  _cleanAllFields() {
    textEditingDurationController.text = _textDefaultDuration;
    textEditingLatitudeController.text = _textDefaultCoordinateLatitude;
    textEditingLongitudeController.text = _textDefaultCoordinateLongitude;
  }
}
