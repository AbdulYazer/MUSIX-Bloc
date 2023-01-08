part of 'bottom_nav_bloc.dart';

@freezed
class BottomNavState with _$BottomNavState {
  const factory BottomNavState({
    required int index
  }) = NewIndex;

  factory BottomNavState.initial() {
    return const BottomNavState(index: 0);
  }
  
}
