namespace demo;

entity Authors {
  key ID   : UUID;
      name : String(100);
      country : String(50);
}

entity Books {
  key ID          : UUID;
      title       : String(100);
      genre       : String(30);
      status      : String(30);
      country     : String(30);
      price       : Decimal(9,2);
      stock       : Integer;
      rating      : Decimal(3,1);
      isActive    : Boolean;
      isAvailable : Boolean;
      publishDate : Date;
      orderDate   : Date;
      hireDate    : Date;
      email       : String(100);
      phone       : String(30);

      author      : Association to Authors;
}