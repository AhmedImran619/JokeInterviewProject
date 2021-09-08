Points that I covered:
    - Amazing UI
    - Login/Sign up
    - List all jokes
    - List my jokes
    - like/dislike joke
    - Add joke to favorite
    - View current user' favorite jokes
    - Submit joke

Bonus points that I covered:
    - Added background color, text, color, fonts , font size
    - Added splash screen

Packages that I used:
    - flutter_screenutil
    - email_validator
    - firebase_auth
    - cloud_firestore
    - firebase_core
    - get
    - provider
    - equatable

DB structure:
    - users => user_id
            => name
            => email
                        => favorites => joke_id

    - jokes => joke_id
            => uploader_id
            => text and other details

    - responses => response_id
                => joke_id
                => user_id
                => response type (like/dislike)
