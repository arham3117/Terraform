// Smooth scrolling for navigation links
function scrollToSection(sectionId) {
    const section = document.getElementById(sectionId);
    if (section) {
        section.scrollIntoView({ behavior: 'smooth' });
    }
}

// Add active state to navigation links based on scroll position
window.addEventListener('scroll', () => {
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('.nav-links a');

    let current = '';

    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;

        if (window.pageYOffset >= sectionTop - 100) {
            current = section.getAttribute('id');
        }
    });

    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${current}`) {
            link.classList.add('active');
        }
    });
});

// Handle contact form submission
function handleSubmit(event) {
    event.preventDefault();

    // Get form values
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const message = document.getElementById('message').value;

    // Simulate form submission
    const messageDiv = document.getElementById('form-message');
    messageDiv.textContent = `Thank you, ${name}! Your message has been received. We'll get back to you at ${email} soon.`;
    messageDiv.className = 'form-message success';

    // Reset form
    document.querySelector('.contact-form').reset();

    // Hide message after 5 seconds
    setTimeout(() => {
        messageDiv.style.display = 'none';
        messageDiv.className = 'form-message';
    }, 5000);

    return false;
}

// Add parallax effect to hero section
window.addEventListener('scroll', () => {
    const hero = document.querySelector('.hero');
    const scrollPosition = window.pageYOffset;

    if (hero) {
        hero.style.transform = `translateY(${scrollPosition * 0.5}px)`;
        hero.style.opacity = 1 - (scrollPosition / 600);
    }
});

// Animate feature cards on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry, index) => {
        if (entry.isIntersecting) {
            setTimeout(() => {
                entry.target.style.animation = 'fadeInUp 0.6s ease-out forwards';
            }, index * 100);
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe all feature cards
document.addEventListener('DOMContentLoaded', () => {
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => {
        card.style.opacity = '0';
        observer.observe(card);
    });
});

// Add hover effect sound (optional - no actual sound, just visual feedback)
document.querySelectorAll('.feature-card').forEach(card => {
    card.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-10px) scale(1.02)';
    });

    card.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0) scale(1)';
    });
});

// Add loading animation
window.addEventListener('load', () => {
    document.body.style.opacity = '0';
    setTimeout(() => {
        document.body.style.transition = 'opacity 0.5s ease-in';
        document.body.style.opacity = '1';
    }, 100);
});

// Console message for developers
console.log('%c🚀 CloudSite', 'font-size: 20px; font-weight: bold; color: #2563eb;');
console.log('%cBuilt with Terraform and deployed on AWS S3 + CloudFront', 'font-size: 12px; color: #6b7280;');
console.log('%cInfrastructure as Code (IaC) for the win!', 'font-size: 12px; color: #10b981;');
