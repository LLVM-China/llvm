; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i386-linux-gnu                       -global-isel -verify-machineinstrs < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE_FAST
; RUN: llc -mtriple=i386-linux-gnu -regbankselect-greedy -global-isel -verify-machineinstrs < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE_GREEDY

;TODO merge with x86-64 tests (many operations not suppored yet)

define i8 @test_load_i8(i8 * %p1) {
; ALL-LABEL: test_load_i8:
; ALL:       # BB#0:
; ALL-NEXT:    movl 4(%esp), %eax
; ALL-NEXT:    movb (%eax), %al
; ALL-NEXT:    retl
  %r = load i8, i8* %p1
  ret i8 %r
}

define i16 @test_load_i16(i16 * %p1) {
; ALL-LABEL: test_load_i16:
; ALL:       # BB#0:
; ALL-NEXT:    movl 4(%esp), %eax
; ALL-NEXT:    movzwl (%eax), %eax
; ALL-NEXT:    retl
  %r = load i16, i16* %p1
  ret i16 %r
}

define i32 @test_load_i32(i32 * %p1) {
; ALL-LABEL: test_load_i32:
; ALL:       # BB#0:
; ALL-NEXT:    movl 4(%esp), %eax
; ALL-NEXT:    movl (%eax), %eax
; ALL-NEXT:    retl
  %r = load i32, i32* %p1
  ret i32 %r
}

define i8 * @test_store_i8(i8 %val, i8 * %p1) {
; ALL-LABEL: test_store_i8:
; ALL:       # BB#0:
; ALL-NEXT:    movb 4(%esp), %cl
; ALL-NEXT:    movl 8(%esp), %eax
; ALL-NEXT:    movb %cl, (%eax)
; ALL-NEXT:    retl
  store i8 %val, i8* %p1
  ret i8 * %p1;
}

define i16 * @test_store_i16(i16 %val, i16 * %p1) {
; ALL-LABEL: test_store_i16:
; ALL:       # BB#0:
; ALL-NEXT:    movzwl 4(%esp), %ecx
; ALL-NEXT:    movl 8(%esp), %eax
; ALL-NEXT:    movw %cx, (%eax)
; ALL-NEXT:    retl
  store i16 %val, i16* %p1
  ret i16 * %p1;
}

define i32 * @test_store_i32(i32 %val, i32 * %p1) {
; ALL-LABEL: test_store_i32:
; ALL:       # BB#0:
; ALL-NEXT:    movl 4(%esp), %ecx
; ALL-NEXT:    movl 8(%esp), %eax
; ALL-NEXT:    movl %ecx, (%eax)
; ALL-NEXT:    retl
  store i32 %val, i32* %p1
  ret i32 * %p1;
}

define i32* @test_load_ptr(i32** %ptr1) {
; ALL-LABEL: test_load_ptr:
; ALL:       # BB#0:
; ALL-NEXT:    movl 4(%esp), %eax
; ALL-NEXT:    movl (%eax), %eax
; ALL-NEXT:    retl
  %p = load i32*, i32** %ptr1
  ret i32* %p
}

define void @test_store_ptr(i32** %ptr1, i32* %a) {
; ALL-LABEL: test_store_ptr:
; ALL:       # BB#0:
; ALL-NEXT:    movl 4(%esp), %eax
; ALL-NEXT:    movl 8(%esp), %ecx
; ALL-NEXT:    movl %ecx, (%eax)
; ALL-NEXT:    retl
  store i32* %a, i32** %ptr1
  ret void
}
