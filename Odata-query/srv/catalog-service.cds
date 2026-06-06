using demo from '../db/schema';

@readonly
service CatalogService {
    entity Books   as projection on demo.Books;
    entity Authors as projection on demo.Authors;
}

service AdminService {
    entity Books   as projection on demo.Books;
    entity Authors as projection on demo.Authors;
}