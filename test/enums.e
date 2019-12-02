This file doesn't compile. It exists for the purpose of testing
the Pygments Specman lexer only.
<'

type car_t: [hyundai, kia] (bits : 3);

extend sys {
   run() is also {
      var my_car: car_t = hyundai;
      var color: [red, blue,green](bits: 2); // enum using 2 bits as storage
      var car: [mercedes = 2, bmw = 4]; // enums with fixed integer representation
      var pet := CAT; // implicityly typed var
   };
};

type value_t: uint(bits: 10);

type value2_t: uint[0..10];

type my_enum0: [ ID0=2 ,
   ID1= 5
];

type my_enum1: [ ID0 = 3
      , ID1];
'>
