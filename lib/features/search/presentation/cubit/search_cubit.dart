import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/search/domain/search_repo.dart';
import 'package:social_media_app/features/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;

  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUser(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUser(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError("Error fetching search"));
    }
  }
}
