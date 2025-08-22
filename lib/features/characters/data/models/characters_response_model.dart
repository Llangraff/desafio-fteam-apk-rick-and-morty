import 'package:json_annotation/json_annotation.dart';
import 'character_model.dart';
import 'page_info_model.dart';

part 'characters_response_model.g.dart';

@JsonSerializable()
class CharactersResponseModel {
  final PageInfoModel info;
  final List<CharacterModel> results;

  const CharactersResponseModel({
    required this.info,
    required this.results,
  });

  factory CharactersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CharactersResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharactersResponseModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharactersResponseModel &&
        other.info == info &&
        other.results.length == results.length &&
        other.results.every((element) => results.contains(element));
  }

  @override
  int get hashCode {
    return Object.hash(info, Object.hashAll(results));
  }

  @override
  String toString() {
    return 'CharactersResponseModel(info: $info, results: ${results.length} characters)';
  }
}