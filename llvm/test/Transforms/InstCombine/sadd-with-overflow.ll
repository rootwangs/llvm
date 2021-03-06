; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32>, <2 x i32>)

declare { i32, i1 } @llvm.sadd.with.overflow.i32(i32, i32)

declare { i8, i1 } @llvm.sadd.with.overflow.i8(i8, i8)

define { i32, i1 } @simple_fold(i32) {
; CHECK-LABEL: @simple_fold(
; CHECK-NEXT:    [[TMP2:%.*]] = add nsw i32 [[TMP0:%.*]], 7
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[TMP2]], i32 13)
; CHECK-NEXT:    ret { i32, i1 } [[TMP3]]
;
  %2 = add nsw i32 %0, 7
  %3 = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %2, i32 13)
  ret { i32, i1 } %3
}

define { i32, i1 } @fold_mixed_signs(i32) {
; CHECK-LABEL: @fold_mixed_signs(
; CHECK-NEXT:    [[TMP2:%.*]] = add nsw i32 [[TMP0:%.*]], 13
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[TMP2]], i32 -7)
; CHECK-NEXT:    ret { i32, i1 } [[TMP3]]
;
  %2 = add nsw i32 %0, 13
  %3 = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %2, i32 -7)
  ret { i32, i1 } %3
}

define { i8, i1 } @no_fold_on_constant_add_overflow(i8) {
; CHECK-LABEL: @no_fold_on_constant_add_overflow(
; CHECK-NEXT:    [[TMP2:%.*]] = add nsw i8 [[TMP0:%.*]], 127
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[TMP2]], i8 127)
; CHECK-NEXT:    ret { i8, i1 } [[TMP3]]
;
  %2 = add nsw i8 %0, 127
  %3 = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %2, i8 127)
  ret { i8, i1 } %3
}

define { <2 x i32>, <2 x i1> } @fold_simple_splat_constant(<2 x i32>) {
; CHECK-LABEL: @fold_simple_splat_constant(
; CHECK-NEXT:    [[TMP2:%.*]] = add nsw <2 x i32> [[TMP0:%.*]], <i32 12, i32 12>
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> [[TMP2]], <2 x i32> <i32 30, i32 30>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[TMP3]]
;
  %2 = add nsw <2 x i32> %0, <i32 12, i32 12>
  %3 = tail call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> %2, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %3
}

define { <2 x i32>, <2 x i1> } @no_fold_splat_undef_constant(<2 x i32>) {
; CHECK-LABEL: @no_fold_splat_undef_constant(
; CHECK-NEXT:    [[TMP2:%.*]] = add nsw <2 x i32> [[TMP0:%.*]], <i32 12, i32 undef>
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> [[TMP2]], <2 x i32> <i32 30, i32 30>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[TMP3]]
;
  %2 = add nsw <2 x i32> %0, <i32 12, i32 undef>
  %3 = tail call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> %2, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %3
}

define { <2 x i32>, <2 x i1> } @no_fold_splat_not_constant(<2 x i32>, <2 x i32>) {
; CHECK-LABEL: @no_fold_splat_not_constant(
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i32> [[TMP0:%.*]], [[TMP1:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = tail call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> [[TMP3]], <2 x i32> <i32 30, i32 30>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[TMP4]]
;
  %3 = add nsw <2 x i32> %0, %1
  %4 = tail call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> %3, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %4
}

define { i32, i1 } @fold_nuwnsw(i32) {
; CHECK-LABEL: @fold_nuwnsw(
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i32 [[TMP0:%.*]], 12
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[TMP2]], i32 30)
; CHECK-NEXT:    ret { i32, i1 } [[TMP3]]
;
  %2 = add nuw nsw i32 %0, 12
  %3 = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %2, i32 30)
  ret { i32, i1 } %3
}

define { i32, i1 } @no_fold_nuw(i32) {
; CHECK-LABEL: @no_fold_nuw(
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw i32 [[TMP0:%.*]], 12
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[TMP2]], i32 30)
; CHECK-NEXT:    ret { i32, i1 } [[TMP3]]
;
  %2 = add nuw i32 %0, 12
  %3 = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %2, i32 30)
  ret { i32, i1 } %3
}
