// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Chart from 'chart.js/auto';

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let hooks = {}
hooks.AllWaste =  {
  dataset() { return JSON.parse(this.el.dataset.waste_bags_of_all_communities); }, 
  mounted() {
    const ctx = this.el;
  const data = {
      type: 'bar',
      data: {
    // random data to validate chart generation
    labels: ['Glass Bags', 'Mixed Bags', 'Paper Bags', 'Plastic Bags', 'Sanitory Bags', 'Seg LF bags'],
        datasets: [{data: this.dataset()}]
   }
  };
    const chart = new Chart(ctx, data);
  }
} 

hooks.TopFiveWaste =  {
  dataset() { return JSON.parse(this.el.dataset.highest_waste_collected); }, 
  mounted() {
    const ctx = this.el;
  const data = {
      type: 'bar',
      data: {
    // random data to validate chart generation
    labels: JSON.parse(this.el.dataset.top_5_community_produce_waste  ),
        datasets: [{data: this.dataset()}]
   }
  };
    const chart = new Chart(ctx, data);
  }
} 

hooks.TopFiveWasteCategoryWise =  {
  glass_bags() { return JSON.parse(this.el.dataset.top_communities_glass_bags);}, 
  mixed_bags() { return JSON.parse(this.el.dataset.top_communities_mixed_bags); }, 
  paper_bags() { return JSON.parse(this.el.dataset.top_communities_paper_bags); }, 
  plastic_bags() { return JSON.parse(this.el.dataset.top_communities_plastic_bags); }, 
  sanitory_bags() { return JSON.parse(this.el.dataset.top_communities_sanitory_bags); }, 
  seg_lf_bags() { return JSON.parse(this.el.dataset.top_communities_seg_lf_bags); }, 

  mounted() {
    const ctx = this.el;
  const data = {
      type: 'bar',
      data: {
    // random data to validate chart generation
    labels: JSON.parse(this.el.dataset.top_5_community_produce_waste),
        datasets: [{data: this.glass_bags()},{data: this.mixed_bags()},{data: this.paper_bags()},{data: this.plastic_bags()},{data: this.sanitory_bags()},{data: this.seg_lf_bags()}  ]
   }
  };
    const chart = new Chart(ctx, data);
  }
} 



let liveSocket = new LiveSocket("/live", Socket, {hooks: hooks, params: {_csrf_token: csrfToken}})


// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

