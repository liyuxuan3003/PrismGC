

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: anlgoic
// Author: 	xg 
// description: sdram write and read operate
//////////////////////////////////////////////////////////////////////////////////


`define   DATA_WIDTH                        32
`define   ADDR_WIDTH                        21
`define   DM_WIDTH                          4
`define   ROW_WIDTH                        11
`define   BA_WIDTH                        2



`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "Anlogic"
`pragma protect encrypt_agent_info = "Anlogic Encryption Tool anlogic_2019"
`pragma protect key_keyowner = "Anlogic", key_keyname = "anlogic-rsa-002"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 128)
`pragma protect key_block
Rg1n8U72YxL8NDjfMuZ/rXkAwe+UYid73uwHvHuzMrehUCQaOyt31EltOUKbPwBe
rnMinBVA4clFF1TfLCM5awd4SlK634nkX859QKVbpaqRd2dOSOiz88eoLm83y8Hp
8PyWkpIbXJJTgsxzV0x169jfW7Fa5OIXm56LvM/fD5Q=
`pragma protect key_keyowner = "Cadence Design Systems.", key_keyname = "CDS_RSA_KEY_VER_1"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 256)
`pragma protect key_block
pHJfr4uTx7ab7bRtPKsqQkk+4e6Js5xs91LyEOD5vOev/ti/WDGRThDLP1NbOFkW
lxgdcaGHk01q8KCmTrBJ9cku2uCzDdqUuBTGgxagsjCx054Fu7Qn7lwnEHF6WmiB
3rgSAZ2t/1frHj6MV8yfONKj1oGVNPSak+KwkglrjI9878SouutRMoLqqgJm+xPg
YDccZ6mXAHNTeVt5ATT/zvKWPC53JWqRKbidwM6A5I0ltoigblPeP/aX3HNr1Q2E
jCxZBtoZ3nQJZxx/FzvbVNOzrP/V0weV7qbpqbzby7WJFnHxiuVsHlinKSK1qKUG
lYTQLXYN47dERE5LMJP1TQ==
`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname = "MGC-VERIF-SIM-RSA-1"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 128)
`pragma protect key_block
WPZu0QqvVKMIOUw2OGTnryKsWDK0+kA+Gh2uuIfBU9U1xa2poEEPaEQDehPCo6Zk
z9g6YZ64xfggOoCsjTeY9Vdz6qJUDHCK1pWzYtrLU+WV0yIRPTcLtsKAStL8ZNRs
agRXETYokgFeK1yFw0whcIPGH+KEqiIMq9rctD6NbnQ=
`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname = "MGC-VERIF-SIM-RSA-2"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 256)
`pragma protect key_block
pQRFaocsa24vJwocKqN445XImAruNvMMTh/PUsgILa38zx+LPE3XmaBWLfhen1Gi
LsshuHuhyPfgrQa4m+/7RFFEWL4LNfC+rR09DQBwGOfxTpV/u4jcGw6swfPN0XOA
PzGQ/nzsdQmI4d1Qn+wG/KCt8ylzZscRl8OxEjwpwJ54a7eFrPIRRtJvmhToDmLP
XImeoZFYCqCwl9PJj2/MXGnelkmyeFAPgR1+isAg/4Tp6FrGyQgou3jvto1vFfxK
3B/OKkDCtFrdXKAXeeNLpBVElCYRcKRhnk5UZ53EgBWBHVVGV17Y1kmBGibtebg2
8YZhTf02os2/LhfnHz9zRA==
`pragma protect key_keyowner = "Synopsys", key_keyname = "SNPS-VCS-RSA-2"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 128)
`pragma protect key_block
bYa8h+KMak7daNHCxMJOBDP41YDDjV+CM0+gwSOxuxrV6ZZKcwbRNQOJbLs72iWe
ezxKxjhPd+wXb5hpbgFGCo6iHywd9UfUinGplH3eOkRgpbDr8apWnrIATNCV3bqB
PpH4sQK0uxQJ/2Ij9abLGNCkArJ7VNbOq+oZ3M8DoVs=
`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 8544)
`pragma protect data_block
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
`pragma protect end_protected
