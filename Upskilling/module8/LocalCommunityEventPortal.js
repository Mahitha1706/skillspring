console.log("Welcome to the Community Portal");

/* =========================
   PAGE LOAD
========================= */

window.onload = function () {

    alert("Community Portal Loaded Successfully");

    loadPreference();

    loadEvents();
};

/* =========================
   EVENT DATA
========================= */

const events = [
    {
        name: "Art Festival",
        category: "Art",
        seats: 25
    },
    {
        name: "Dance Competition",
        category: "Dance",
        seats: 15
    },
    {
        name: "Music Night",
        category: "Music",
        seats: 40
    },
    {
        name: "Sports Meet",
        category: "Sports",
        seats: 20
    }
];

/* =========================
   CLASS
========================= */

class Event {

    constructor(name, category, seats) {
        this.name = name;
        this.category = category;
        this.seats = seats;
    }

    checkAvailability() {
        return this.seats > 0;
    }
}

/* =========================
   DISPLAY EVENTS
========================= */

function loadEvents() {

    events.forEach(event => {
        console.log(
            `${event.name} - Seats Available: ${event.seats}`
        );
    });
}

/* =========================
   PHONE VALIDATION
========================= */

function validatePhone() {

    const phone =
        document.getElementById("phone").value;

    const regex = /^[0-9]{10}$/;

    if (!regex.test(phone)) {

        alert(
            "Phone number must contain exactly 10 digits."
        );
    }
}

/* =========================
   EVENT FEE
========================= */

function showFee() {

    const selected =
        document.getElementById("eventType").value;

    const feeList = {
        Art: 100,
        Dance: 150,
        Music: 200,
        Sports: 250
    };

    document.getElementById("feeDisplay")
        .innerHTML =
        "Event Fee : ₹ " +
        (feeList[selected] || 0);

    localStorage.setItem(
        "preferredEvent",
        selected
    );
}

/* =========================
   CHARACTER COUNTER
========================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        const feedback =
            document.getElementById("feedback");

        if (feedback) {

            feedback.addEventListener(
                "keyup",
                function () {

                    document.getElementById(
                        "charCount"
                    ).innerHTML =
                        this.value.length +
                        " Characters";
                }
            );
        }
    }
);

/* =========================
   FORM SUBMISSION
========================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        const form =
            document.getElementById(
                "registrationForm"
            );

        if (form) {

            form.addEventListener(
                "submit",
                async function (event) {

                    event.preventDefault();

                    const name =
                        document.getElementById("name").value;

                    const email =
                        document.getElementById("email").value;

                    const eventType =
                        document.getElementById("eventType").value;

                    if (
                        name === "" ||
                        email === "" ||
                        eventType === ""
                    ) {

                        document.getElementById(
                            "outputMessage"
                        ).innerHTML =
                            "Please fill all required fields.";

                        return;
                    }

                    document.getElementById(
                        "outputMessage"
                    ).innerHTML =
                        "Submitting Registration...";

                    try {

                        await fakeAPI();

                        document.getElementById(
                            "outputMessage"
                        ).innerHTML =
                            "Registration Successful ✅";

                    } catch {

                        document.getElementById(
                            "outputMessage"
                        ).innerHTML =
                            "Registration Failed ❌";
                    }
                }
            );
        }
    }
);

/* =========================
   MOCK API
========================= */

function fakeAPI() {

    return new Promise(
        (resolve) => {

            setTimeout(() => {

                resolve();

            }, 2000);
        }
    );
}

/* =========================
   VIDEO EVENT
========================= */

function videoReady() {

    document.getElementById(
        "videoStatus"
    ).innerHTML =
        "Video Ready To Play";
}

/* =========================
   LOCAL STORAGE
========================= */

function loadPreference() {

    const saved =
        localStorage.getItem(
            "preferredEvent"
        );

    if (saved) {

        document.getElementById(
            "eventType"
        ).value = saved;

        showFee();
    }
}

/* =========================
   CLEAR STORAGE
========================= */

function clearPreferences() {

    localStorage.clear();

    sessionStorage.clear();

    alert("Preferences Cleared");
}

/* =========================
   GEOLOCATION
========================= */

function findLocation() {

    if (
        navigator.geolocation
    ) {

        navigator.geolocation.getCurrentPosition(

            function (position) {

                document.getElementById(
                    "location"
                ).innerHTML =

                    `Latitude : ${position.coords.latitude}
                     <br>
                     Longitude : ${position.coords.longitude}`;
            },

            function (error) {

                document.getElementById(
                    "location"
                ).innerHTML =
                    error.message;
            },

            {
                enableHighAccuracy: true,
                timeout: 5000
            }
        );

    } else {

        alert(
            "Geolocation Not Supported"
        );
    }
}

/* =========================
   IMAGE DOUBLE CLICK
========================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        const images =
            document.querySelectorAll(
                ".gallery-img"
            );

        images.forEach(
            image => {

                image.addEventListener(
                    "dblclick",
                    function () {

                        if (
                            image.style.transform ===
                            "scale(1.6)"
                        ) {

                            image.style.transform =
                                "scale(1)";

                        } else {

                            image.style.transform =
                                "scale(1.6)";
                        }
                    }
                );
            }
        );
    }
);

/* =========================
   BEFORE UNLOAD
========================= */

window.onbeforeunload =
    function () {

        return "Unsaved registration details may be lost.";
    };
