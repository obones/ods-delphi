{**************************************************************************************************}
{                                                                                                  }
{ ODS-Delphi                                                                                       }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is ods.LinearHashTable.pas.                                                         }
{                                                                                                  }
{ The Initial Developer of the Original Code is Olivier Sannier (obones).                          }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributors:                                                                                    }
{                                                                                                  }
{**************************************************************************************************}
unit ods.LinearHashTable;

interface

uses
  System.Generics.Defaults;

type
  TLinearHashTable<T> = class
  private
    const w: Integer = 32;
    const r: Integer = 8;
  private
    FComparer: IComparer<T>;
    table: TArray<T>;
    n: Integer;   // number of values in table
    q: Integer;   // number of non-null entries in table
    d: Integer;   // Length(table) = 2^d
    null: T;
    del: T;

    procedure resize();
    function hash(x: T): Integer;
    function SameValue(A, B: T): Boolean;
    procedure FillWithNull(var ATable: TArray<T>);

    // Sample code for the book only -- never use this
    (*
    int idealHash(x: T) {
      return tab[hashCode(x) >> w-d];
    }
    *)
  protected
    function hashCode(x: T): Cardinal; virtual;
  public
    // FIXME: get rid of default constructor
    constructor DontCreate; overload;
    constructor Create(null: T; del: T); overload;
    constructor Create(null: T; del: T; AComparer: IComparer<T>); overload;
    function add(x: T): Boolean;
    function addSlow(x: T): Boolean;
    function remove(x: T): T;
    function find(x: T): T;
    function size(): Integer; inline; { return n; }
    procedure clear();
    // FIXME: yuck
    procedure setNull(null: T); inline; { this->null = null; t.fill(null); }
    procedure setDel(del: T); inline; { this->del = del; }
  end;

const
  tab: array [0..3, 0..255] of Cardinal =
  (
    (
      $0069aeff, $6ac0719e, $384cd7ee, $cba78313, $133ef89a, $b37979e6, $a4c4e09c, $911c738b,
      $c7fe9194, $ba8e5dc7, $e610718c, $48460ac5, $6b4d9d43, $73afeeab, $051264cb, $4b3dba93,
      $28837665, $fb80a52b, $ad1c14af, $b2baf17f, $35e311a5, $f7fa2905, $a973c315, $00885f47,
      $8842622b, $0445a92c, $701ba3a0, $ef608902, $176099ad, $d240f938, $b32d83c6, $b341afb8,
      $c3a978fb, $55ed1f0c, $b581286e, $8ff6938e, $9f11c1c5, $4d083bd6, $1aacc2a4, $df13f00a,
      $1e282712, $772d354b, $21e3a7fd, $4bc932dc, $e1deb7ba, $5e868b8a, $c9331cc6, $aa931bbf,
      $ff92aba6, $e3efc69f, $da3b8e2a, $f9b21ec1, $2fb89674, $61c87462, $a553c2f9, $ca01e279,
      $35999337, $f44c4fd3, $136a2773, $812607a8, $bfcd9bbf, $0b1d15cd, $c2a0038b, $029ab4f7,
      $cd7c58f9, $ed3821c4, $325457c6, $1dc6b295, $876dcb83, $52df45fc, $a01c9fba, $c938ff66,
      $19e52c87, $03ae67f9, $7db39e51, $74f31686, $5f10e5a3, $74108d8a, $64e63104, $d86a38d6,
      $65be2fbb, $ef06049e, $9bca1dbd, $06c63e73, $e97bd103, $fed3c22c, $09d10fc6, $b92633a3,
      $21378ebf, $e37fa54e, $893c7910, $c1c74a5a, $6c23c029, $4d4b6187, $d72bb8fb, $0dbe1118,
      $5e0f4188, $ce0d2dc8, $8dd83231, $0466ab90, $814bc11a, $ef688b9b, $0a03c851, $ca3c984f,
      $6df87ca4, $6b34d1b2, $2bad5c75, $aed1b6d8, $8c73f8b4, $4577d798, $5c953767, $e7da2d51,
      $2b9279a0, $418d9b51, $8c47ec3d, $894e6119, $a0ca769d, $1c3b16a4, $a1621b5b, $a695da53,
      $22462819, $f4b878cf, $72b4d648, $1faf4267, $4ba16750, $08a9d645, $6bfb829c, $e051295f,
      $6dd5cd97, $2e9d1baf, $6ed6231d, $6f84cb25, $9ae60c95, $bcee55ca, $6831cd97, $2ccdbc99,
      $9f8a0a81, $a0b2c08f, $e957c36b, $9cb797b5, $107c6362, $48dacf5d, $6e16f569, $39be78c3,
      $6445637f, $ed445ee5, $8ec45004, $9ef8a405, $b5796a45, $049d5143, $b3c1d852, $c36d9b44,
      $ab0da981, $ff5226b3, $19169b4c, $9a49194d, $ba218b42, $ab98c8ee, $4db02645, $6faca3c8,
      $12c60d2d, $af67b750, $f0f6a855, $ead566d9, $42d0cccd, $76a532bb, $82a6dc35, $c1c23d0e,
      $83d45bd2, $d7024912, $97888901, $2b7cdd2c, $523742a5, $ecb96b3b, $d800d833, $7b4d0c91,
      $95c7dd86, $88880aad, $f0ce0990, $7e292a90, $79ac4437, $8a9f59cc, $818444d1, $ae4e735d,
      $a529db95, $58b35661, $a909a7de, $9273beaa, $fe94332c, $259b88e4, $c88f4f6a, $2a9d33ef,
      $4b5d106d, $dc3a9fca, $a8061cad, $7679422c, $af72ad02, $c5799ea5, $306d694d, $620aad10,
      $d188b9dd, $eff6ad87, $6b890354, $b5907cd3, $733290fc, $4b6c0733, $0bad0ebd, $a049d3ad,
      $c9d0cdae, $9c144d6f, $5990b63b, $fa33d8e2, $9ebeb5a0, $bc7c5c92, $d3edd2e6, $54ae1af6,
      $d6ada4bd, $14094c5a, $0e3c5adf, $f1ab60f1, $74456a66, $0f3a675a, $87445d0d, $a81adc2e,
      $0f47a1a5, $4eedb844, $9c9cb0ce, $8bb3d330, $02df93e6, $86e3ad51, $1c1072b9, $acf3001b,
      $bd08c487, $c2667a11, $dd5ef664, $d47b67fb, $959cca45, $a7da8e68, $b75b1e18, $75201924,
      $e689ab8b, $0f5e6b0a, $75205923, $bba35593, $d24dab24, $0288caeb, $cbf022a9, $392d7ee5,
      $16fe493a, $b6bcadfd, $9813ec72, $9aa3d37c, $ee88a59e, $6cdbad4e, $6b96aabf, $cb54d5e5
    ),
    (
      $116fc403, $260d7e7b, $def689e7, $a5b3d49a, $921f3594, $b24c8cba, $1bdefb3f, $6519e846,
      $24b37253, $1cc6b12b, $6f48f06e, $ca90b0db, $8e20570b, $da75ed0f, $1b515143, $0990a659,
      $dcedb6b3, $ec22de79, $dd56f7a9, $901194a6, $4bf3db02, $5d31787d, $d24da2ca, $9fc9bc14,
      $9aa38ac9, $e95972ba, $8233a732, $b9d4317e, $51f9b329, $94f12c56, $1ace26e4, $ecda5183,
      $1353e547, $39b99ab3, $6413ac97, $eb6b5334, $dd94ed2b, $298e9d2c, $d38abc91, $3f17ee4e,
      $99f8931d, $88bae7da, $b5506a36, $2d7baf6d, $42a98d2b, $bb9b94b9, $58820083, $521bba4c,
      $76699597, $137b86be, $8533888e, $b37316dd, $284c3de4, $fe60e3e6, $94edaa40, $919c85cd,
      $24cb6f23, $6b446fbd, $be933c15, $2a43951a, $791a9f90, $47977c04, $a6350eec, $95e817a5,
      $ffc82e8c, $ad379229, $6ec9531a, $8cab29f9, $b2f18402, $d0ebdac1, $d7b559b4, $7ad30e7c,
      $e1d1adb7, $58a66f9c, $7a26636a, $8c865f92, $65363517, $732b87db, $64a1ad52, $72e87c39,
      $0b943e4d, $532d3593, $edcf9975, $44b5bec1, $13ac91f8, $6e6f3a76, $36ac3c6d, $528a3ecf,
      $f3d8cd75, $8facd64c, $db4d13d5, $80d49a67, $aa7061d3, $9486ba8d, $7454a65b, $18e7b707,
      $d9cc05b9, $44eb014d, $28ba26d8, $a8852791, $f8dc3053, $abe46b52, $9e261d1f, $768f83dd,
      $1c888838, $6d9b9ce6, $69e82575, $2959538f, $d0ff9685, $92b4540c, $7c93035b, $7cad90ad,
      $49aaa908, $3981f4b8, $191f4339, $d0971bfc, $a7209692, $0e253cad, $40e2ee61, $c5c63486,
      $df4f238b, $2d3cb89a, $3b5704b2, $cc14c2cb, $b1698d38, $079c3b9b, $bb3867e4, $9f01e223,
      $35e69012, $5c87d888, $2cea4193, $ee088da5, $0ea4d5ab, $8a4906e8, $f6e5e283, $ee87fa18,
      $9f96c751, $947252c0, $9b50b97e, $05952521, $9440f5ae, $a0642786, $ebcc62be, $adccf011,
      $00b863e6, $1c3ab5b3, $7c701e4b, $a9565792, $b1ad459c, $833ba164, $89544ae3, $35540c75,
      $198d0fec, $be93bf33, $c28444b3, $bc3add48, $b4300c14, $ee0ed408, $ca08ada3, $0be06480,
      $c4dd8ce2, $61195564, $5b10a111, $65cd2b3b, $cbeb06ae, $fce70080, $ef40b102, $fc0bfe6f,
      $8111bf20, $fb166db1, $3598b2ef, $1e0e04de, $1bf7cf2d, $0de7eaf1, $829457e0, $e8865341,
      $826272ad, $b57db2a4, $7413e6e7, $416323ff, $8e08d503, $1da4dfac, $983b9a78, $0fab5fe0,
      $585e7a90, $038cf73c, $ecf90d31, $046055c8, $59926d71, $06959f1f, $3b8290b7, $0bb834d9,
      $a0dc5bec, $ec9ae604, $6ebfd59d, $feccbab5, $240bd4ba, $2df2b232, $e14e0383, $d86526ec,
      $e3d974fc, $940662b5, $81abf5d4, $8010e6eb, $700d9849, $040d0c42, $c980417b, $95fa374a,
      $724b1448, $217205ec, $0153b4bb, $ea55ea92, $2049d5a1, $82576f06, $586fcfeb, $a975e489,
      $14c862e9, $acb8b52c, $2f3fb91e, $ce273650, $66608f4a, $24f81bb7, $0382dc34, $07bdc163,
      $c42ad034, $e63cf998, $1a61f233, $d5754ebe, $37275214, $2322de2a, $3a53b9b4, $ab9c6963,
      $2f3a51be, $5066e7c7, $941bda97, $75fadceb, $d05ad081, $f77d5daf, $d9879250, $ebf8bf97,
      $65be4a70, $388eda48, $728173fb, $05975bfa, $314dad8a, $2cb4909f, $c736b716, $9007296d,
      $4fd61551, $d4378ccf, $649aac3e, $d9ca1a9d, $16ff16ae, $8090f1c5, $fe0c4703, $c4152307
    ),
    (
      $f07e5e34, $62114ba6, $f45ffe22, $baa48702, $e27e48a4, $c43b4779, $549a4566, $93bc4836,
      $3b2e8d46, $3f8a77ae, $71e2d944, $c09c5dce, $ebfbfd4f, $7f8e1c40, $3c310a69, $52f62f09,
      $b7fd11bb, $a9d055a7, $e3bd4654, $9696ae10, $df953225, $42fd2380, $69756e5c, $9d950bc4,
      $e2beea59, $d33daa07, $e97d31ce, $d9fb0a49, $553a27f2, $7166586f, $eb04d48c, $72adb63a,
      $340ab99e, $459b4609, $481421b7, $7db83c71, $192f6c22, $711852a8, $c6bd6562, $b91be2c8,
      $efe89dbf, $c404eb9b, $9ebc1bc7, $8dc7eed2, $4d84efd7, $0783d7e5, $3b5ca2f2, $9997e51c,
      $89b432c9, $72ae9672, $61d522d9, $a639fd45, $a7da3b46, $696e73ec, $89581a95, $4aa25f94,
      $d0eb2a48, $04865f68, $1cbd651a, $d6b2afd9, $d401b965, $d20aa5a7, $c0aa1b15, $fb4ce7af,
      $159974c5, $15d0841d, $6b2836b4, $ef3b3edf, $af2db0b3, $13106fb6, $ff41d7f9, $ab2a698d,
      $68e04dc9, $e5ee0099, $e50d4017, $5ea78d6d, $2e18fb07, $fe22b9ff, $544c05f1, $c2e10853,
      $8d151bd6, $17ee763a, $a663ce31, $4a4b5e33, $298b13c1, $d3b40c89, $121b6b4e, $59cf0429,
      $3d0bab9d, $d24c5dfe, $5bb7349f, $ac5dbfe9, $7eca5ebb, $adb8b3e3, $71ab540b, $c8e3dc0d,
      $12e6cd3f, $8197f22c, $5ff77265, $e5641dbc, $818ab24c, $627b98f7, $dd84e1d6, $531c2346,
      $ec2f4e3c, $4a3cb318, $70cb24fe, $35c17bfe, $ec91fd18, $6efb3c18, $16908369, $41732188,
      $449e658b, $2e9931cb, $67cd066e, $883ca306, $f66aecac, $979bf015, $8e85e27d, $0560372b,
      $987995d6, $aff98ed7, $552ee87b, $21a53787, $3d3cfd45, $a084dae0, $8c91be2f, $ac4c3550,
      $a7db63ff, $124b2f23, $95d05d4e, $b983db13, $a929a3c1, $111cd0a0, $f59ded9a, $ce677ae3,
      $fa949e59, $d673e658, $f8c8e27b, $3c60fc3d, $59a4f230, $f54a5e87, $08cff440, $d4bbb1ee,
      $6a0c7db0, $ecbaa99d, $ec61dcaf, $f1056e2b, $54236899, $adad347c, $c9885bc9, $2fe2a4ec,
      $01ba2b86, $6b23f604, $b354ef08, $6a3dc5e2, $ab61da36, $7543925a, $0a558940, $48d4d8f3,
      $d84f2f6f, $6ac5311c, $cd1b660e, $51293d3d, $a0f15790, $d629cd78, $89201fa5, $46005119,
      $9617fa14, $c375a68b, $7ccb519b, $6420a714, $b736d2ce, $154fcf4a, $71cad2f5, $acb150d7,
      $97bc8e36, $c5506d0a, $a9facc35, $1a9630db, $bd3d72ee, $58cdf27c, $17f3e1f9, $41598836,
      $d6adac30, $309a5b3f, $3bd3aa32, $40f08f50, $f37cbd6c, $cbdb8aef, $e0819189, $5a9b663b,
      $6932a448, $b1b3e866, $c50ee24d, $ad999126, $afb04056, $c95974e5, $636a64fa, $0bb12dd9,
      $78caa164, $d26a7ec8, $451a0b53, $6d00aac6, $484d1d9d, $39728dd4, $fbfec2ea, $a6d5aaf9,
      $91c4f6ea, $31cab009, $9b6ba4e8, $e271ed67, $4c87a84d, $8a1a4567, $93749497, $c566edcc,
      $c8229554, $927925fd, $ad1caced, $dc24f7ed, $c92b9220, $936cd037, $bd2d0256, $5c92409b,
      $a3aa2682, $4da97646, $bcfdec81, $25d5b61d, $20e1660d, $4b5214ed, $91aa596a, $b241415c,
      $88ec91a1, $2375e939, $981ad627, $4a54ee18, $13d98660, $9375c64d, $538d3b28, $4bf37ca7,
      $192b351e, $3cacf215, $3ecf3565, $50f5c0fc, $aafe3d4e, $6351b4f5, $1b800d4f, $fad73cdf,
      $e300e1d8, $b2cb5b04, $fb019702, $fb647f85, $375a7b74, $ed6a6760, $45c54e76, $06524d79
    ),
    (
      $48722ec4, $8a2694db, $3cf80478, $f9bc47ba, $76b258fb, $f71a1ec6, $841189df, $1a866461,
      $72b5488c, $71663983, $bda59407, $a2b68f85, $62dbd0aa, $e4966aa3, $32e0efaa, $71bb3699,
      $2eda14a6, $53f8917c, $874974ce, $e680bcca, $96a9c462, $399ca451, $c46616f5, $eee71114,
      $5878e472, $3a83c559, $54862a18, $82aea480, $492d0019, $d62a7027, $36655f50, $ce412fdf,
      $c8136871, $d6cfe1d8, $121c9c91, $13abbf51, $3aaa7037, $9f6e7cb6, $ae82c4c4, $55fdce32,
      $d8dd6bda, $d6ec4938, $6a5aee52, $52c8a764, $a6a85297, $5131de9e, $396a6599, $e27b1100,
      $e68588d3, $7b89a612, $ad48a7a4, $fd205673, $81807089, $239d2d38, $39518df3, $256f3f14,
      $5c65e7b8, $64caebdc, $d8d694b6, $b4a87da3, $a651881e, $ca1d252d, $993a3ddc, $14f9a54d,
      $6b14d2ff, $bbed03bb, $8d12bc03, $6cce455d, $613d6487, $6d04ce6a, $c2f4c84c, $306d8ff2,
      $584a9847, $68902fc5, $70af1a4f, $3ab4cb98, $e8be4453, $7e95d355, $84b0f371, $4c5ccb52,
      $dd6d029c, $afa47124, $71aabf91, $d3407f95, $e7fa3a9c, $4f634405, $0cbf2cb7, $0192ff17,
      $296959dd, $9e4d34d5, $fd9a4286, $ac7b6933, $4650f585, $168af40d, $73816119, $5542d96d,
      $99047276, $1b5bbe67, $01a8209e, $6f9db32e, $d762bbd1, $299a3804, $87abe66d, $d479eeaa,
      $79928f4e, $3937ffbc, $3c8e83ca, $2a8f9347, $4d2324d3, $f0183dda, $9fbedb15, $ac365889,
      $f1be552c, $a4b32d5a, $dc77fff3, $9d516da8, $7f3c347c, $39e8479f, $9e869687, $6a160347,
      $49ab7403, $830d31c7, $11311354, $79e6cc69, $35b25caa, $398af9aa, $02ef4356, $b5ecba53,
      $666d6c8b, $8836b3ae, $23b9fc98, $0cc8e3d0, $3ad594e1, $b124529d, $e059c1de, $fa88e0d9,
      $ba117846, $1782a65a, $ee9f80f9, $bc9aec55, $88aec1d4, $9c3907fa, $92b7b5bf, $464acbf4,
      $bbbd04a8, $f0e966bf, $14c5f971, $83018d49, $faf4fc0a, $3b4639b2, $6b7e297d, $c0e9a807,
      $418713d3, $1a2b2361, $80850d90, $d515816e, $3deb48ea, $6bfe6aa1, $3680036c, $228e76ae,
      $78f16c87, $ff4d85ea, $7d831974, $ba962d6b, $4bae0b1d, $c0db431a, $04b46400, $cf427175,
      $244e321d, $1c8b1fc9, $63a2b794, $1939d9c6, $c92a530e, $21a8e5ad, $28050194, $3b106223,
      $b21e2ce1, $7ae71fe4, $7f7759f0, $0329c8f4, $d09f6b37, $897e12a5, $4103c4b1, $56520dae,
      $5d7391aa, $7ac9f12d, $eac6b834, $99f8f6a8, $2867867a, $ff6f3343, $3167097a, $38432d1d,
      $108377f8, $fd8e0d5f, $25e15692, $f00d40f9, $1f1276f3, $b748c8cd, $6dbb9d9c, $99ab7ceb,
      $a4a9784f, $cb4b2535, $b3eb5ca7, $d3a09e75, $90f3ee7e, $28ef2a57, $bdb643a2, $1112ab10,
      $546b1af2, $8c41e90d, $0f5fcd88, $6f259f40, $34b33966, $5f3558d7, $fff36f0b, $a3459449,
      $dcecbce1, $69ff2bf7, $7525e1da, $24c9de72, $ea9626b1, $87c7385d, $15e4211e, $9f7ef269,
      $fed018d1, $7632076c, $8d4f0157, $10c1205a, $65db0e00, $813f0e8b, $bafea255, $b47e6663,
      $2a0eba78, $f66b3783, $fff1db48, $47997f03, $3a49e877, $4536a0b5, $89b0738f, $f5758b5e,
      $1d277388, $f5db28e8, $b4ef0add, $776fed12, $045b614a, $c95f47ae, $13a1d602, $217d6338,
      $c509d080, $006789de, $d891cccc, $b02f9980, $67f00301, $afc87999, $043d8fbd, $b32d6061
    )
  );

implementation

uses
  System.SysUtils;

{ TLinearHashTable<T> }

function TLinearHashTable<T>.add(x: T): Boolean;
var
  i: Integer;
begin
  if not SameValue(find(x), null) then
    Exit(false);
  if 2*(q+1) > Length(table) then
    resize();   // max 50% occupancy
  i := hash(x);
  while not SameValue(table[i], null) and not SameValue(table[i], del) do
    if i = Length(table) then
      i := 0
    else
      i := i + 1;
  if SameValue(table[i], null) then
    Inc(q);
  Inc(n);
  table[i] := x;
  Result := true;
end;

function TLinearHashTable<T>.addSlow(x: T): Boolean;
var
  i: Integer;
begin
  if 2*(q+1) > Length(table) then
    resize();   // max 50% occupancy
  i := hash(x);
  while not SameValue(table[i], null) do
  begin
    if not SameValue(table[i], del) and SameValue(x, table[i]) then
      Exit(false);
    if i = Length(table)-1 then
      i := 0
    else
      i := i + 1; // increment i
  end;
  table[i] := x;
  Inc(n);
  Inc(q);

  Result := true;
end;

procedure TLinearHashTable<T>.clear;
begin
  n := 0;
  q := 0;
  d := 1;
  SetLength(table, 2);
  FillWithNull(table);
end;

constructor TLinearHashTable<T>.Create(null, del: T; AComparer: IComparer<T>);
begin
  inherited Create;

  FComparer := AComparer;
  Self.null := null;
  Self.del := del;
  Clear;
end;

constructor TLinearHashTable<T>.Create(null, del: T);
begin
  Create(null, del, TComparer<T>.Default);
end;

constructor TLinearHashTable<T>.DontCreate;
begin
(**
 * FIXME: Dangerous - leaves null and del uninitialized
 *)
(*
  Self.null := null;
  Self.del := del;
*)
  n := 0;
  q := 0;
  d := 1;
end;

procedure TLinearHashTable<T>.FillWithNull(var ATable: TArray<T>);
var
  I: Integer;
begin
  for I := 0 to Length(ATable) - 1 do
    ATable[I] := null;
end;

function TLinearHashTable<T>.find(x: T): T;
var
  i: Integer;
begin
  i := hash(x);
  while not SameValue(table[i], null) do
  begin
    if not SameValue(table[i], del) and SameValue(table[i], x) then
      Exit(table[i]);
    if i = Length(table)-1 then
      i := 0
    else
      i := i + 1;
  end;
  Result := null;
end;

function TLinearHashTable<T>.hash(x: T): Integer;
var
  h: Cardinal;
begin
  h := hashCode(x);
  Result := (tab[0][h and $ff]
           xor tab[1][(h shr 8) and $ff]
           xor tab[2][(h shr 16) and $ff]
           xor tab[3][(h shr 24) and $ff])
          shr (w-d);
end;

function TLinearHashTable<T>.hashCode(x: T): Cardinal;
begin
  raise EAbstractError.CreateFmt('hashCode is not implemented in %s', [ClassName]);
end;

function TLinearHashTable<T>.remove(x: T): T;
var
  i: Integer;
  y: T;
begin
  i := hash(x);
  while not SameValue(table[i], null) do
  begin
    y := table[i];
    if not SameValue(y, del) and SameValue(x, y) then
    begin
      table[i] := del;
      Dec(n);
      if 8*n < Length(table) then
        resize(); // min 12.5% occupancy
      Exit(y);
    end;
    if i = Length(table)-1 then
      i := 0
    else
      i := i + 1;
  end;
  Result := null;
end;

procedure TLinearHashTable<T>.resize;
var
  newTable: TArray<T>;
  k: Integer;
  i: Integer;
begin
  d := 1;
  while (1 shl d) < 3*n do
    Inc(d);
  SetLength(newTable, 1 shl d);
  FillWithNull(newTable);
  q := n;
  // insert everything into tnew
  for k := 0 to Length(table) - 1 do
  begin
    if not SameValue(table[k], null) and not SameValue(table[k], del) then
    begin
      i := hash(table[k]);
      while not SameValue(NewTable[i], null) do
        if i = Length(NewTable)-1 then
          i := 0
        else
          i := i + 1;
      NewTable[i] := table[k];
    end;
  end;
  table := NewTable;
end;

function TLinearHashTable<T>.SameValue(A, B: T): Boolean;
begin
  Result := FComparer.Compare(A, B) = 0;
end;

procedure TLinearHashTable<T>.setDel(del: T);
begin
  Self.del := del;
end;

procedure TLinearHashTable<T>.setNull(null: T);
begin
  Self.null := null;
  FillWithNull(table);
end;

function TLinearHashTable<T>.size: Integer;
begin
  Result := n;
end;

end.