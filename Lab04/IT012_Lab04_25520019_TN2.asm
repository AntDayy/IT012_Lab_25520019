# Ho ten: Nguyen Thien An - MSSV: 25520019 - Muc dich: Phan bac dien nang tieu thu (1..4)
# Ke hoach dung thanh ghi:
# $s0: dien nang nhap vao (kWh) | $s1: bac gia dien (1..4) | $t0: ket qua so sanh slti

.data
prompt: .asciiz "Nhap dien nang (kWh): "
msg:    .asciiz "Bac: "
nl:     .asciiz "\n"
 
.text
.globl main
main:
  # In thong bao va nhap dien nang tu ban phim
  li   $v0, 4
  la   $a0, prompt
  syscall
  li   $v0, 5            # doc kWh, ket qua o $v0
  syscall
  add  $s0, $v0, $zero   # $s0 = dien nang (kWh)

  # Xac dinh bac (1..4) theo Bang 6, dat vao $s1
  slti $t0, $s0, 101     # $t0 = 1 neu $s0 <= 100
  bne  $t0, $zero, Bac1  # nhay den Bac1
  
  slti $t0, $s0, 151     # $t0 = 1 neu $s0 <= 150
  bne  $t0, $zero, Bac2  # nhay den Bac2
  
  slti $t0, $s0, 201     # $t0 = 1 neu $s0 <= 200
  bne  $t0, $zero, Bac3  # nhay den Bac3
  
  addi $s1, $zero, 4     # con lai (>= 201) la bac 4
  j    Print  

Bac1:
  addi $s1, $zero, 1     # gan bac 1
  j    Print
  
Bac2:
  addi $s1, $zero, 2     # gan bac 2
  j    Print
  
Bac3:
  addi $s1, $zero, 3     # gan bac 3
  j    Print
  
Print:
  # In "Bac: ", roi $s1, roi xuong dong
  li   $v0, 4
  la   $a0, msg
  syscall
  li   $v0, 1
  add  $a0, $s1, $zero   # in gia tri bac ($s1)
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall
  
  li   $v0, 10           # ket thuc chuong trinh
  syscall