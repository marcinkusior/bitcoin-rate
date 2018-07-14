const margin = Object.freeze({
  top: 60,
  right: 50,
  bottom: 20,
  left: 50
});

class LineGraph {
  constructor (el, data, currency) {
    this.el = el;
    this.data = data;
    this.currency = currency;
  }

  createGraph () {
    this._setSizeParameters();
    this._createSvgElement();
    this._createGraphLayer();
    this._prepareXScale();
    this._prepareYScale();
    this._drawXaxis();
    this._drawYaxis();
    this._drawValueLine();
    this._addInteractiveLayer();
    this._addInteractiveElements();
    this._addInteraction();
    return this;
  }

  _setSizeParameters () {
    this.width = this.el.clientWidth;
    this.height = this.el.clientHeight;
    this.graphWidth = this.width - margin.left - margin.right;
    this.graphHeight = this.height - margin.top - margin.bottom;
  }

  _createSvgElement () {
    this.svg = d3.select(this.el).append('svg');
  }

  _prepareXScale () {
    this.x = d3.scaleTime().range([0, this.graphWidth]);
    this.x.domain(d3.extent(this.data, d => new Date(d.date)));
  }

  _prepareYScale () {
    this.y = d3.scaleLinear().range([this.graphHeight, 0]);
    this.y.domain(d3.extent(this.data, d => d.value));
  }

  _createGraphLayer () {
    this.graphLayer = this.svg.append('g')
      .attr('class', 'graph-layer')
      .attr('transform', `translate(${margin.left}, ${margin.top})`);
  }

  _drawXaxis () {
    this.graphLayer.append('g')
      .attr('class', 'axis axis-x')
      .attr('transform', `translate(0, ${this.graphHeight})`)
      .call(d3.axisBottom(this.x).ticks(6));
  }

  _drawYaxis () {
    this.graphLayer.append('g')
      .attr('class', 'axis axis-y')
      .call(d3.axisLeft(this.y).ticks(5).tickSize(-this.graphWidth))
      .attr('transform', `translate(0, 0)`)
      .selectAll('text').attr('x', -15);
  }

  _drawValueLine () {
    this.graphLayer.append('path')
      .data([this.data])
      .attr('d', this._valueLine())
      .attr('fill', 'none')
      .attr('stroke', 'black')
      .attr('stroke-width', '1px');
  }

  _valueLine () {
    return d3.line()
      .x(d => this.x(new Date(d.date)))
      .y(d => this.y(d.value));
  }

  _addInteractiveLayer () {
    this.interactiveLayer = this.graphLayer.append('rect')
      .attr('fill', 'transparent')
      .attr('class', 'interactive-layer')
      .attr('width', this.graphWidth)
      .attr('height', this.graphHeight);
  }

  _addFocusLine () {
    this.focusLine = this.graphLayer.append('line')
      .attr('class', 'focus-line')
      .attr('x1', 10)
      .attr('x2', 10)
      .attr('y1', 0)
      .attr('y2', this.graphHeight)
      .attr('stroke', 'black');
  }

  _moveFocusLine (x) {
    this.focusLine
      .attr('x1', x)
      .attr('x2', x);
  }

  _addFocusCircle () {
    this.focusCircle = this.graphLayer.append('circle')
      .attr('class', 'focus-circle')
      .attr('cx', 10)
      .attr('cy', 10)
      .attr('r', 6)
      .attr('fill', 'grey');
  }

  _moveFocusCircle (x, y) {
    this.focusCircle
      .attr('cx', x)
      .attr('cy', y);
  }

  _addTooltip () {
    this.tooltip = this.graphLayer.append('g')
      .attr('class', 'tooltip')
      .attr('x', 0)
      .attr('y', 0);

    this.tooltip.append('rect')
      .attr('x', 0)
      .attr('y', 0)
      .attr('width', 100)
      .attr('height', 50)
      .attr('fill', 'lightgrey');

    this.tooltipDate = this.tooltip.append('text')
      .attr('x', 6)
      .attr('y', 20)
      .attr('font-family', 'sans-serif')
      .attr('font-size', '12px')
      .attr('fill', 'black');

    this.tooltipValue = this.tooltip.append('text')
      .attr('x', 6)
      .attr('y', 36)
      .attr('font-family', 'sans-serif')
      .attr('font-size', '12px')
      .attr('font-weight', 800)
      .attr('fill', 'black');
  }

  _moveTooltip (x, y) {
    const tooltipWidth = this.tooltip.node().getBBox().width;
    const tooltipHeight = this.tooltip.node().getBBox().height;

    this.tooltip.attr('transform', `translate(${x - tooltipWidth / 2}, ${y - tooltipHeight - 10})`);
  }

  _changeTooltipText (data) {
    this.tooltipDate.text(data.date);
    this.tooltipValue.text(Math.round(data.value * 100) / 100);
  }

  _addInteractiveElements () {
    this._addFocusLine();
    this._addFocusCircle();
    this._addTooltip();
    this._disableFocus();
  }

  _addInteraction () {
    const self = this;
    this.interactiveLayer
      .on('mouseover', this._enableFocus.bind(this))
      .on('mouseout', this._disableFocus.bind(this))
      .on('mousemove', function () {
        const mouseXposition = d3.mouse(this)[0];
        const dataIndex = self._getDataIndex(mouseXposition);
        const dataInFocus = self.data[dataIndex];
        self._moveFocusElements(dataInFocus);
      });
  }

  _moveFocusElements (dataInFocus) {
    const x = this.x(new Date(dataInFocus.date));
    const y = this.y(dataInFocus.value);

    this._moveFocusLine(x);
    this._moveFocusCircle(x, y);
    this._moveTooltip(x, y);
    this._changeTooltipText(dataInFocus);
  }

  _enableFocus () {
    this.focusLine.attr('display', 'block');
    this.focusCircle.attr('display', 'block');
    this.tooltip.attr('display', 'block');
  }

  _disableFocus () {
    this.focusLine.attr('display', 'none');
    this.focusCircle.attr('display', 'none');
    this.tooltip.attr('display', 'none');
  }

  _getDataIndex (mouseXposition) {
    const bisectDate = d3.bisector(d => new Date(d.date)).left;

    const x0 = this.x.invert(mouseXposition);
    const idx = bisectDate(this.data, x0, 1);

    const d0 = new Date(this.data[idx - 1].date);
    const d1 = new Date(this.data[idx].date);

    const diff0 = x0 - d0;
    const diff1 = d1 - x0;

    return diff0 < diff1 ? idx - 1 : idx;
  }
}
