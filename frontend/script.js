async function getWeather() {
    const city = document.getElementById('city').value;

    const response = await fetch(
        API_URL + '?city=' + encodeURIComponent(city)
    );

    const data = await response.json();

    document.getElementById('result').innerHTML = `
        <h2>${data.name}</h2>
        <p>Temperature : ${data.main.temp} °C</p>
        <p>Humidity : ${data.main.humidity}%</p>
        <p>Wind : ${data.wind.speed} m/s</p>
        <p>${data.weather[0].description}</p>
    `;
}
