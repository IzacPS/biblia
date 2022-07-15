part of 'dropdown_menu_select_cubit.dart';

abstract class DropdownMenuSelectState<T extends Object> extends Equatable {
  final T? value;
  final List<T>? list;
  const DropdownMenuSelectState({this.value, this.list});

  @override
  List<Object?> get props => [value, list];
}

class DropdownMenuSelectInitial<T extends Object>
    extends DropdownMenuSelectState<T> {
  const DropdownMenuSelectInitial(List<T>? l) : super(list: l);
}

class DropdownMenuSelectSetValue<T extends Object>
    extends DropdownMenuSelectState<T> {
  const DropdownMenuSelectSetValue(T? v, List<T>? l) : super(value: v, list: l);
}
