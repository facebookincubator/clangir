; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -two-entry-phi-node-folding-threshold=0 -phi-node-folding-threshold=4 < %s | FileCheck %s

declare void @sideeffect0()
declare void @sideeffect1()
declare void @sideeffect2()

define i32 @unknown(i1 %c, i32 %a, i32 %b) {
; CHECK-LABEL: @unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[C:%.*]], label [[DISPATCH:%.*]], label [[END:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[VAL:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[CMP]], i32 [[VAL]], i32 0
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ -1, [[ENTRY:%.*]] ], [ [[SPEC_SELECT]], [[DISPATCH]] ]
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  call void @sideeffect0()
  br i1 %c, label %dispatch, label %end

dispatch:
  call void @sideeffect1()
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %cond.true, label %end

cond.true:
  %val = add i32 %a, %b
  br label %end

end:
  %res = phi i32 [ -1, %entry ], [ 0, %dispatch ], [ %val, %cond.true ]
  call void @sideeffect2()
  ret i32 %res
}

define i32 @predictably_taken(i1 %c, i32 %a, i32 %b) {
; CHECK-LABEL: @predictably_taken(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[C:%.*]], label [[DISPATCH:%.*]], label [[END:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[VAL:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[CMP]], i32 [[VAL]], i32 0, !prof [[PROF0:![0-9]+]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ -1, [[ENTRY:%.*]] ], [ [[SPEC_SELECT]], [[DISPATCH]] ]
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  call void @sideeffect0()
  br i1 %c, label %dispatch, label %end

dispatch:
  call void @sideeffect1()
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %cond.true, label %end, !prof !0 ; likely branches to %cond.true

cond.true:
  %val = add i32 %a, %b
  br label %end

end:
  %res = phi i32 [ -1, %entry ], [ 0, %dispatch ], [ %val, %cond.true ]
  call void @sideeffect2()
  ret i32 %res
}

define i32 @predictably_nontaken(i1 %c, i32 %a, i32 %b) {
; CHECK-LABEL: @predictably_nontaken(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[C:%.*]], label [[DISPATCH:%.*]], label [[END:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[VAL:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[CMP]], i32 0, i32 [[VAL]], !prof [[PROF0]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ -1, [[ENTRY:%.*]] ], [ [[SPEC_SELECT]], [[DISPATCH]] ]
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  call void @sideeffect0()
  br i1 %c, label %dispatch, label %end

dispatch:
  call void @sideeffect1()
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %end, label %cond.true, !prof !0 ; likely branches to %end

cond.true:
  %val = add i32 %a, %b
  br label %end

end:
  %res = phi i32 [ -1, %entry ], [ 0, %dispatch ], [ %val, %cond.true ]
  call void @sideeffect2()
  ret i32 %res
}

define i32 @unpredictable(i1 %c, i32 %a, i32 %b) {
; CHECK-LABEL: @unpredictable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[C:%.*]], label [[DISPATCH:%.*]], label [[END:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[VAL:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[CMP]], i32 [[VAL]], i32 0, !unpredictable !1
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ -1, [[ENTRY:%.*]] ], [ [[SPEC_SELECT]], [[DISPATCH]] ]
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  call void @sideeffect0()
  br i1 %c, label %dispatch, label %end

dispatch:
  call void @sideeffect1()
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %cond.true, label %end, !unpredictable !1 ; unpredictable

cond.true:
  %val = add i32 %a, %b
  br label %end

end:
  %res = phi i32 [ -1, %entry ], [ 0, %dispatch ], [ %val, %cond.true ]
  call void @sideeffect2()
  ret i32 %res
}

define i32 @unpredictable_yet_taken(i1 %c, i32 %a, i32 %b) {
; CHECK-LABEL: @unpredictable_yet_taken(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[C:%.*]], label [[DISPATCH:%.*]], label [[END:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[VAL:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[CMP]], i32 [[VAL]], i32 0, !prof [[PROF0]], !unpredictable !1
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ -1, [[ENTRY:%.*]] ], [ [[SPEC_SELECT]], [[DISPATCH]] ]
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  call void @sideeffect0()
  br i1 %c, label %dispatch, label %end

dispatch:
  call void @sideeffect1()
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %cond.true, label %end, !prof !0, !unpredictable !1 ; likely branches to %cond.true, yet unpredictable

cond.true:
  %val = add i32 %a, %b
  br label %end

end:
  %res = phi i32 [ -1, %entry ], [ 0, %dispatch ], [ %val, %cond.true ]
  call void @sideeffect2()
  ret i32 %res
}

define i32 @unpredictable_yet_nontaken(i1 %c, i32 %a, i32 %b) {
; CHECK-LABEL: @unpredictable_yet_nontaken(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[C:%.*]], label [[DISPATCH:%.*]], label [[END:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[VAL:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[CMP]], i32 0, i32 [[VAL]], !prof [[PROF0]], !unpredictable !1
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ -1, [[ENTRY:%.*]] ], [ [[SPEC_SELECT]], [[DISPATCH]] ]
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  call void @sideeffect0()
  br i1 %c, label %dispatch, label %end

dispatch:
  call void @sideeffect1()
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %end, label %cond.true, !prof !0, !unpredictable !1 ; likely branches to %end, yet unpredictable

cond.true:
  %val = add i32 %a, %b
  br label %end

end:
  %res = phi i32 [ -1, %entry ], [ 0, %dispatch ], [ %val, %cond.true ]
  call void @sideeffect2()
  ret i32 %res
}

!0 = !{!"branch_weights", i32 99, i32 1}
!1 = !{}

; CHECK: !0 = !{!"branch_weights", i32 99, i32 1}
; CHECK: !1 = !{}