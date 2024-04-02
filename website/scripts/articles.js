async function fetchData() {
    let response = await fetch("articles/data.json");
    let data = await response.json();
    return data;
}

fetchData().then(result => {
    let container = document.querySelector(".blog-wrap");
    let slide = null;
    result.forEach((element, index) => {
        if (index % 3 === 0) {
            slide = document.createElement('div');
            slide.classList = "swiper-slide swiper-item";
            container.appendChild(slide);
        }
        let article = document.createElement('article');
        article.classList = "blog-item";
        article.innerHTML = `<img class="blog-img"
        src="${element.img}"
        alt="blog_photo" width="250" height="200">
        <div class="blog-info">
        <h3 class="blog-subtitle subtitle">${element.title}</h3>
        <p class="blog-text">${element.description}</p>
        <a class="blog-link"
            href="${element.link}"
            target="_blank">Read more</a>
    </div>
        `;
        slide.appendChild(article);
    });
});

let swiper = new Swiper(".mySwiperBlog", {
    slidesPerView: 1,
    spaceBetween: 0,
    pagination: {
      el: ".swiper-pagination",
      clickable: true,
    },
    navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
  });
