; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=ipsccp < %s -S | FileCheck %s

define void @barney() {
; CHECK-LABEL: @barney(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB9:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    unreachable
; CHECK:       bb9:
; CHECK-NEXT:    br label [[BB6:%.*]]
;
bb:
  br label %bb9

bb6:                                              ; preds = %bb9
  unreachable

bb7:                                              ; preds = %bb9
  unreachable

bb9:                                              ; preds = %bb
  switch i16 0, label %bb6 [
  i16 61, label %bb7
  ]
}

define void @blam() {
; CHECK-LABEL: @blam(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB16:%.*]]
; CHECK:       bb16:
; CHECK-NEXT:    br label [[BB38:%.*]]
; CHECK:       bb38:
; CHECK-NEXT:    unreachable
;
bb:
  br label %bb16

bb16:                                             ; preds = %bb
  switch i32 0, label %bb38 [
  i32 66, label %bb17
  i32 63, label %bb18
  i32 86, label %bb19
  ]

bb17:                                             ; preds = %bb16
  unreachable

bb18:                                             ; preds = %bb16
  unreachable

bb19:                                             ; preds = %bb16
  unreachable

bb38:                                             ; preds = %bb16
  unreachable
}


define void @hoge() {
; CHECK-LABEL: @hoge(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    unreachable
;
bb:
  switch i16 undef, label %bb1 [
  i16 135, label %bb2
  i16 66, label %bb2
  ]

bb1:                                              ; preds = %bb
  ret void

bb2:                                              ; preds = %bb, %bb
  switch i16 0, label %bb3 [
  i16 61, label %bb4
  i16 54, label %bb4
  i16 49, label %bb4
  ]

bb3:                                              ; preds = %bb2
  unreachable

bb4:                                              ; preds = %bb2, %bb2, %bb2
  unreachable
}
