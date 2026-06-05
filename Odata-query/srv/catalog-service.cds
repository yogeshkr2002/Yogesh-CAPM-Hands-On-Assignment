using demo from '../db/schema';

service CatalogService {
    entity Books   as projection on demo.Books;
    entity Authors as projection on demo.Authors;
}