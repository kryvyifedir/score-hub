import { LightningElement } from 'lwc';

export default class Confetti extends LightningElement {
    confettiArray = [];
    containerClass = 'confetti-container';

    // Generates the confetti on component load
    connectedCallback() {
        this.generateConfetti();
    }

    // Generates the confetti and updates their styles
    generateConfetti() {
        for (let i = 0; i < 100; i++) {
            this.confettiArray.push({
                id: i,
                style: this.generateConfettiStyle()
            });
        }

        // Updates the confetti styles every 50 milliseconds
        setInterval(() => {
            this.confettiArray = this.confettiArray.map(confetti => {
                return {
                    ...confetti,
                    style: this.updateConfettiStyle(confetti.style)
                };
            });
        }, 50);
    }

    // Generates the initial styles for the confetti
    generateConfettiStyle() {
        const x = Math.floor(Math.random() * window.innerWidth);
        const y = Math.floor(Math.random() * -window.innerHeight);
        const size = Math.floor(Math.random() * 5 + 5);
        const color = this.generateRandomColor();

        return `left: ${x}px; top: ${y}px; width: ${size}px; height: ${size}px; background-color: ${color};`;
    }

    // Updates the styles for the confetti
    updateConfettiStyle(style) {
        const currentTop = parseInt(style.split(';')[1].split(':')[1]);
        const updatedTop = currentTop + 10;

        return style.replace(`top: ${currentTop}px`, `top: ${updatedTop}px`);
    }

    // Generates a random color for the confetti
    generateRandomColor() {
        const colorArray = ['red', 'green', 'blue', 'purple', 'orange'];
        const randomIndex = Math.floor(Math.random() * colorArray.length);

        return colorArray[randomIndex];
    }
}