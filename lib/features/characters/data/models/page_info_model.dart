import 'package:json_annotation/json_annotation.dart';

part 'page_info_model.g.dart';

@JsonSerializable()
class PageInfoModel {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const PageInfoModel({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory PageInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PageInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageInfoModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PageInfoModel &&
        other.count == count &&
        other.pages == pages &&
        other.next == next &&
        other.prev == prev;
  }

  @override
  int get hashCode {
    return Object.hash(count, pages, next, prev);
  }

  @override
  String toString() {
    return 'PageInfoModel(count: $count, pages: $pages, next: $next, prev: $prev)';
  }
}