import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_state.g.dart';

@JsonSerializable()
class PageState extends Equatable {
  final int currentPage;
  final int nextPage;

  const PageState(this.currentPage, this.nextPage);

  factory PageState.fromJson(Map<String, dynamic> json) =>
      _$PageStateFromJson(json);

  Map<String, dynamic> toJson() => _$PageStateToJson(this);

  @override
  List<Object?> get props => [currentPage, nextPage];
}
