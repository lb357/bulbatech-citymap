var maps_url = "https://www.openstreetmap.org/#map=19/";
var officialToken = "";
var ticket_html = "";
fetch('/static/ticket.html', {method: 'GET'}).then((response) => {return response.text();}).then((html) => {ticket_html = html});
var page = 0;


function login(){
    officialToken = document.getElementById("token").value;
    fetch('/official/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({"official_token": officialToken})
    }).then((response) => {
        return response.text();
    }).then((html) => {
        document.body.innerHTML = html;
        onLogin();
    });
}




function onLogin(){
    setPage(0);
}


function addTicket(ticket_id, user_id, title, text, point, timestamp, pinned, official_comment, files, rating){
    var ticketDiv = document.createElement('div');
    ticketDiv.innerHTML = ticket_html;
    for (const file of files) {
        var link = document.createElement("a");
        link.href = file;
        link.innerText = "Вложенный файл";
        ticketDiv.appendChild(link);
    }
    ticketDiv.querySelector("#title").innerText = title;
    ticketDiv.querySelector("#ticket_id").innerText = "ID тикета: " + ticket_id;
    ticketDiv.querySelector("#user_id").innerText = "ID пользователя: " + user_id;
    ticketDiv.querySelector("#text").innerText = text;
    ticketDiv.querySelector("#time").innerText = (new Date(timestamp * 1000)).toString();

    ticketDiv.querySelector("#point").href = maps_url+point[0]+"/"+point[1];

    if (pinned) {
        ticketDiv.querySelector("#pinned").innerText = "Закреплен";
    } else {
        ticketDiv.querySelector("#pinned").innerText = "Не закреплен";
    }
    ticketDiv.querySelector("#pin_button").onclick = function(){
        pin(ticket_id);
    };

    ticketDiv.querySelector("#rating").innerText = "Рейтинг: " + rating;

    if (official_comment == "") {
        ticketDiv.removeChild(ticketDiv.querySelector("#official_comment"));
        ticketDiv.querySelector("#official_comment_input").id = "official_comment_input"+"_"+ticket_id;
        ticketDiv.querySelector("#official_comment_button").onclick = function(){
            comment(ticket_id);
        };
        ticketDiv.removeChild(ticketDiv.querySelector("#archive_button"));
    } else {
        ticketDiv.querySelector("#official_comment").innerText = "Официальный ответ:\n" + official_comment;
        ticketDiv.removeChild(ticketDiv.querySelector("#official_comment_input"));
        ticketDiv.removeChild(ticketDiv.querySelector("#official_comment_button"));
        ticketDiv.querySelector("#archive_button").onclick = function(){
            archive(ticket_id);
        };
    }
    document.getElementById("feed").appendChild(ticketDiv);
}


function comment(ticket_id) {
    var value = document.getElementById("official_comment_input_"+ticket_id).value;
    fetch('/api/official-comment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({"official_token": officialToken, "ticket_id": ticket_id, "text": value})
    }).then((response) => {
        setPage(page);
    });
}

function pin(ticket_id) {
    fetch('/api/pin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({"official_token": officialToken, "ticket_id": ticket_id})
    }).then((response) => {
        setPage(page);
    });
}

function archive(ticket_id) {
    fetch('/api/archive', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({"official_token": officialToken, "ticket_id": ticket_id})
    }).then((response) => {
        setPage(page);
    });
}

function setPage(idx) {
    if (idx < 0){
        page = 0;
    } else {
        page = idx;
    }
    loadPage();
}

function loadPage(){
    const parent = document.getElementById("feed")
    while (parent.firstChild) {
        parent.firstChild.remove()
    }

    fetch('/api/feed?category=-1&page='+page, {
        method: 'GET'
    }).then((response) => {
        return response.text();
    }).then((text_data) => {
        var data = JSON.parse(text_data);
        for (const ticket of data["tickets"]){
            addTicket(
                ticket["ticket_id"],
                ticket["user_id"],
                ticket["title"],
                ticket["text"],
                ticket["point"],
                ticket["timestamp"],
                ticket["pinned"],
                ticket["official_comment"],
                ticket["files_json"],
                ticket["rating"]
            );
        }
    });
    fetch('/api/statistic', {method: 'GET'}).then((response) => {return response.text();}).then((text_data) => {
        var data = JSON.parse(text_data);
        document.getElementById("statistic").innerText = "Тикетов: " + data["tickets"] + " / Официальных ответов: "+ data["official_comments"] + " / Ожидают ответа: " + (data["tickets"]-data["official_comments"]) + " / Уникальных пользователей: " + data["users"]
    });
}