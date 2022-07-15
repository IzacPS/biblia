import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dropdown_menu_select_state.dart';

class DropdownMenuSelectCubit<T extends Object>
    extends Cubit<DropdownMenuSelectState<T>> {
  DropdownMenuSelectCubit({List<T>? list})
      : super(DropdownMenuSelectInitial(list));

  void setValue(T? value, List<T>? l) {
    emit(DropdownMenuSelectSetValue(value, l));
  }
}
