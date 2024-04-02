let swiperFirst = new Swiper(".mySwiperGuides", {
    slidesPerView: 1,
    spaceBetween: 30,
    pagination: {
        el: ".btns-pagination",
        clickable: true,
    },
    navigation: {
        nextEl: ".btn-next",
        prevEl: ".btn-prev",
    },
});