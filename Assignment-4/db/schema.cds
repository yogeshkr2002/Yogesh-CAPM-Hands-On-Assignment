namespace platform.events;

type Email  : String(100);
type Phone  : String(15);
type Amount : Decimal(12,2);
type Rating : Decimal(2,1);
type Name   : String(100);
type URL    : String(255);


type VenueType : String enum {
    Auditorium;
    ConferenceHall;
    Outdoor;
    Virtual;
};

type EventType : String enum {
    Conference;
    Workshop;
    Seminar;
    Webinar;
    Meetup;
};

type EventStatus : String enum {
    Draft;
    Published;
    Ongoing;
    Completed;
    Cancelled;
};

type TicketType : String enum {
    General;
    VIP;
    Student;
};

type RegistrationStatus : String enum {
    Confirmed;
    Cancelled;
    Waitlisted;
    Attended;
};



entity Venues {

    key ID          : UUID;

    name            : Name;
    address         : String(255);
    city            : String(50);

    capacity        : Integer;

    type            : VenueType;

    amenities       : String(255);

    hourlyRate      : Amount;

    contactPerson   : Name;

    phone           : Phone;

    isActive        : Boolean default true;
}

entity Events {

    key ID          : UUID;

    title           : String(150);

    description     : String(500);

    eventType       : EventType;

    venue           : Association to Venues;

    startDate       : Date;
    endDate         : Date;

    startTime       : Time;
    endTime         : Time;

    maxAttendees    : Integer;

    registeredCount : Integer default 0;

    ticketPrice     : Amount;

    status          : EventStatus default 'Draft';

    organizerName   : Name;

    organizerEmail  : Email;

    tags            : String(255);
}

entity Speakers {

    key ID          : UUID;

    name            : Name;

    email           : Email;

    phone           : Phone;

    bio             : String(500);

    company         : String(100);

    designation     : String(100);

    expertise       : String(255);

    photoUrl        : URL;

    rating          : Rating;

    totalTalks      : Integer;

    isActive        : Boolean default true;
}

entity EventSpeakers {

    key event       : Association to Events;
    key speaker     : Association to Speakers;

    topic           : String(255);

    sessionTime     : Time;

    sessionDuration : Integer;

    roomNumber      : String(20);
}

entity Registrations {

    key ID              : UUID;

    event               : Association to Events;

    attendeeName        : Name;

    attendeeEmail       : Email;

    attendeePhone       : Phone;

    company             : String(100);

    ticketType          : TicketType;

    registrationDate    : Date;

    status              : RegistrationStatus default 'Confirmed';

    amountPaid          : Amount;

    paymentId           : String(100);
}

entity Feedback {

    key ID              : UUID;

    event               : Association to Events;

    attendeeEmail       : Email;

    overallRating       : Rating;

    contentRating       : Rating;

    venueRating         : Rating;

    speakerRating       : Rating;

    comment             : String(500);

    submittedAt         : DateTime;
}