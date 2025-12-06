const API_URL = window.location.origin;

async function loadVersion() {
    const res = await fetch(`${API_URL}/health`);
    const data = await res.json();
    document.getElementById("version").textContent = data.version;
}
loadVersion();

async function getFruits() {
    const res = await fetch(`${API_URL}/api/fruits`);
    const data = await res.json();
    const list = document.getElementById("fruits");
    list.innerHTML = "";

    data.forEach(f => {
        const li = document.createElement("li");
        li.textContent = `${f.id} - ${f.name} ($${f.price})`;
        list.appendChild(li);
    });
}

async function createReservation() {
    const body = {
        fruitId: Number(document.getElementById("fruitId").value),
        userName: document.getElementById("userName").value,
        quantity: Number(document.getElementById("quantity").value),
    };

    const res = await fetch(`${API_URL}/api/reservations`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body)
    });

    const data = await res.json();
    document.getElementById("reservationResult").textContent = JSON.stringify(data);
}
