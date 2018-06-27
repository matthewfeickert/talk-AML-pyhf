class: middle, center, title-slide
count: false

# `pyhf`: pure-Python
# implementation of HistFactory

<br>

(for the dev team)<br>
Matthew Feickert<br>
[matthew.feickert@cern.ch](mailto:matthew.feickert@cern.ch)

[Joint ATLAS Machine Learning & Statistics Fora Meeting](https://indico.cern.ch/event/757657/)

September 19th, 2018

---

# Collaborators

<br><br>

<!-- .center[
.circle.width-30[![Lukas Heinrich](figures/collaborators/heinrich.jpg)] &nbsp;
.circle.width-30[![Giordon Stark](figures/collaborators/stark.jpg)] &nbsp;
![Kyle Cranmer](figures/collaborators/cranmer.png)
] -->
.grid[
.kol-1-3.center[
<!-- .circle.width-80[![Lukas](https://avatars1.githubusercontent.com/u/2318083?s=400&v=4)] -->
.circle.width-80[![Lukas](figures/collaborators/heinrich.jpg)]

[Lukas Heinrich](https://github.com/lukasheinrich)

NYU
]
.kol-1-3.center[
.circle.width-80[![Giordon](figures/collaborators/stark.jpg)]

[Giordon Stark](https://github.com/kratsg)

UCSC SCIPP
]
.kol-1-3.center[
<!-- .circle.width-70[![Kyle](https://raw.githubusercontent.com/glouppe/talk-lfi-effectively/master/figures/faces/kyle.png)] -->
.circle.width-70[![Kyle](figures/collaborators/cranmer.png)]

[Kyle Cranmer](http://theoryandpractice.org/)

NYU
]
]

---

# `pyhf`?

<br>

- First non-ROOT implementation of the HistFactory p.d.f. template
   - pure-Python library
      - [`pip install pyhf`](https://diana-hep.org/pyhf/installation.html#install-from-pypi)
   - machine learning frameworks as computational backends
      - [`pip install pyhf[tensorflow]`](https://diana-hep.org/pyhf/installation.html#with-tensorflow-backend)
- Alternative choice to ROOT-based HistFactory to use in the analysis pipeline of HistFitter + HistFactory + RooStats
   - Project scope: HistFactory
   - Not a replacement for HistFitter or RooStats
- Open source tool for all of HEP
   - Originated from a [DIANA/HEP](https://diana-hep.org/) project fellowship
   - Not experiment specific (though designed by ATLAS physicists)
   - Have contributions from [CMS members](https://github.com/diana-hep/pyhf/commit/4159c2dbc9ed7a9b3866e9b127d885d696314754) and [strong interest by theorists](https://indico.cern.ch/event/689514/contributions/2961925/)

---

# HistFactory

<br>

- A flexible p.d.f template to build statistical models from binned distributions and data
<!-- - Developed by Cranmer, et al. [1] -->
- Developed by Cranmer, Lewis, Moneta, Shibata, and Verkerke [1]
- Widely used by the HEP community for standard model measurements and BSM searches
   <!-- - Show public summary plots and link to references that use HistFactory (multi b-jets for example) -->

.kol-1-1.center[
.width-100[![HistFactory_uses](figures/HistFactory_result_examples.png)]
]
---

# HistFactory Template

<br>

$$\begin{aligned}
&\mathcal{P}\left(n\_{c}, x\_{e}, a\_{p} \middle|\phi\_{p}, \alpha\_{p}, \gamma\_{b} \right) = \\\\
&{\color{blue}{\prod\_{c \\,\in\\, \textrm{channels}} \left[\textrm{Pois}\left(n\_{c} \middle| \nu\_{c}\right) \prod\_{e=1}^{n\_{c}} f\_{c}\left(x\_{e} \middle| \vec{\alpha}\right)\right]}} {\color{red}{G\left(L\_{0} \middle| \lambda, \Delta\_{L}\right) \prod\_{p\\, \in\\, \mathbb{S}+\Gamma} f\_{p}\left(a\_{p} \middle| \alpha\_{p}\right)}}
\end{aligned}$$

.bold[Use:] Multiple disjoint _channels_ (or regions) of binned distributions with multiple _samples_ contributing to each with additional (possibly shared) systematics between sample estimates

.bold[Main pieces:]

- .blue[Poisson p.d.f. for bins observed in all channels]
- .red[Constraint p.d.f. (+ data) for "auxiliary measurements"]
   - encoding systematic uncertainties (normalization, shape, etc)

---

# HistFactory Template

$$\begin{aligned}
&\mathcal{P}\left(n\_{c}, x\_{e}, a\_{p} \middle|\phi\_{p}, \alpha\_{p}, \gamma\_{b} \right) = \\\\
&\prod\_{c \\,\in\\, \textrm{channels}} \left[\textrm{Pois}\left(n\_{c} \middle| \nu\_{c}\right) \prod\_{e=1}^{n\_{c}} f\_{c}\left(x\_{e} \middle| \vec{\alpha}\right)\right] G\left(L\_{0} \middle| \lambda, \Delta\_{L}\right) \prod\_{p\\, \in\\, \mathbb{S}+\Gamma} f\_{p}\left(a\_{p} \middle| \alpha\_{p}\right)
\end{aligned}$$

.bold[This is a mathematical representation!] Nowhere is any software spec defined

Until now, the only implementation of HistFactory has been in RooStats+RooFit

- To start using HistFactory p.d.f.s first have to learn ROOT, RooFit, RooStats
   - Problem for our theory colleagues (generally don't want to)
- Possible issues with scaling I/O and memory for large models
   - Not multithreaded
- Difficult to interface with modern tools for minimization and computation of the p.d.f.
- Likelihood stored in the binary ROOT format
   - Challenge for long-term preservation (i.e. HEPData)
   - Why is a histogram needed for an array of numbers?

---

# HistFactory in ROOT Environment

.center.width-100[![HistFactory_in_ROOT](figures/HistFactory_in_ROOT.png)]

.footnote[[Image credit: Lukas Heinrich](https://indico.cern.ch/event/754255/contributions/3129528/)]

---

# HistFactory with `pyhf`

.center.width-100[![HistFactory_in_pyhf](figures/HistFactory_in_pyhf.png)]

.footnote[[Image credit: Lukas Heinrich](https://indico.cern.ch/event/754255/contributions/3129528/)]
---

class: middle

.center[Additionally allows for interactive visualization]

<br>

.center.width-100[<iframe width="560" height="315" src="https://www.youtube.com/embed/9egt9ZTm7T0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>]

.footnote[Image credit: Lukas Heinrich]
---

# What does `pyhf` provide?

1\. .bold[standalone pure-Python HistFactory implementation] including hooks into
modern deep-learning, autodifferentiable tensor libraries

- implementation of asymptotic interval estimation algorithm based
on profile likelihood test-statistic

2\. .bold[pure JSON schema] to distribute and archive HistFactory models
ingredients without any reliance on binary formats

.grid[
.kol-1-3.center[
<!-- .width-100[![ROOT](https://raw.githubusercontent.com/diana-hep/pyhf/master/docs/_static/img/hfh_1bin_55_50_7.png)] -->
.width-100[![ROOT](figures/ROOT_CLs.png)]

ROOT
]
.kol-1-3.center[
<!-- .width-100[![pyhf](https://raw.githubusercontent.com/diana-hep/pyhf/master/docs/_static/img/manual_1bin_55_50_7.png)] -->
.width-100[![pyhf](figures/pyhf_CLs.png)]

pyhf
]
.kol-1-3.center[
.width-100[![overlay](figures/overlay.png)]

Same Result
]
]

---

class: middle
<!-- # `pyhf` goals -->

- .bold[a useful template for all of HEP]
   - easy to use alternative implementation for non-ROOT software stack
- .bold[open industry standard file formats]
   - JSON will be with us for a long long time
- .bold[hardware acceleration]
   - CPU → GPU with a simple boolean switch
- .bold[machine learning framework backends]
   - Full gradients for minimization
- .bold[path to distributed, cluster-based computation]
   - Coming soon: [Dask](http://dask.pydata.org/en/latest/) backend
- .bold[easy reinterpretation]
- .bold[toy and asymptotic calculations]
   - In now: asymptotics
   - Coming soon: sampling (think [`tfp`](https://github.com/tensorflow/probability))

---

# Machine Learning Frameworks for Computational Backends

.grid[
.kol-2-3[

All numerical operations implemented in .bold[tensor backends] through an API of $n$-dimensional array operations

Allows for switching out the tensor backend with a single call

Using deep learning frameworks as computational backends allows for .bold[exploitation of auto differentiation (autograd) and GPU acceleration]

As huge buy in from industry we benefit for free as these frameworks are .bold[continually improved] by professional software engineers

]
.kol-1-3.center[
<!-- .width-40[![Tensorflow](https://upload.wikimedia.org/wikipedia/commons/2/2d/Tensorflow_logo.svg)] -->
.width-40[![Tensorflow](figures/logos/Tensorflow_logo.svg)]

<br>

<!-- .width-100[![PyTorch](https://pytorch.org/tutorials/_static/pytorch-logo-dark.svg)] -->
.width-100[![PyTorch](figures/logos/pytorch-logo-dark.svg)]

<br>

<!-- .width-100[![MXNet](https://raw.githubusercontent.com/dmlc/web-data/master/mxnet/image/mxnet_logo_2.png)] -->
.width-100[![MXNet](figures/logos/mxnet_logo_2.png)]
]
]

---

class: middle

.bold[Automatic differentiation ([autograd](http://www.columbia.edu/~ahd2125/post/2015/12/5/))]

.grid[
.kol-2-3[
With ML backends in `pyhf` gain access to exact (higher order) derivatives of the likelihood during minimization &mdash; accuracy is only limited by floating point error

$$
\frac{\partial L}{\partial \mu}, \frac{\partial L}{\partial \theta_{i}}
$$

Gain this through the frameworks creating directed computational directed acyclic graphs and then applying the chain rule (to the operations)

.center.width-70[![DAG](figures/directed_acyclic_graph.png)]
]
.kol-1-3[
.center.width-50[![Dask_DAG](figures/Dask_DAG.png)]

simple DAG from `pyhf`
]
]

.footnote[[Image credit: Alan Du](http://www.columbia.edu/~ahd2125/post/2015/12/5/)]
---

class: middle

.bold[GPU Acceleration]

- Machine Learning community specializes in making tensor
computations as fast as possible by exploiting GPUs
   - gains in the GPU backends translate directly to gains within `pyhf`
- In the process of benchmarking performance of `pyhf` with CPU vs. GPU
- Working to add [CuPy backend](https://github.com/cupy/cupy) as compliment of NumPy
- Future work: Support non-NVIDIA GPUs through [OpenCL](https://www.khronos.org/opencl/)

---

# Enough talk...live demo time!

<br><br>

.center.bold[Just click the button!]<br><br><br>

.center.width-70[[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/diana-hep/pyhf/talk/AML-and-stats-forum-meeting?filepath=docs%2Fexamples%2Fnotebooks%2Ftalks%2FAML-and-Stats-Forum-Demo.ipynb)]

---

# [Hello World, `pyhf` style](https://diana-hep.org/pyhf/examples/notebooks/hello-world.html)

<br>

.bold[Two bin counting experiment with a background uncertainty]

```python
# Python3
>>> import pyhf
>>> import pyhf.simplemodels
>>> import pyhf.utils
>>>
>>> pdf = pyhf.simplemodels.hepdata_like(signal_data=[12., 11.],
                                         bkg_data=[50., 52.],
                                         bkg_uncerts=[3., 7.])
>>> *_, CLs_obs, CLs_exp = pyhf.utils.runOnePoint(
        1.0, [51, 48] + pdf.config.auxdata, pdf)
>>> print('Observed: {} Expected: {}'.format(CLs_obs, CLs_exp[2]))
Observed: [0.05290116] Expected: [0.06445521]
```

---

# $CL_{s}$ Example using `pyhf` CLI

<a href="https://carbon.now.sh/?bg=rgba(255%2C255%2C255%2C1)&t=seti&wt=none&l=application%2Fjson&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=%257B%250A%2520%2520%2520%2520%2522channels%2522%253A%2520%255B%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2522name%2522%253A%2520%2522singlechannel%2522%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2522samples%2522%253A%2520%255B%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2522name%2522%253A%2520%2522sig%2522%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2522data%2522%253A%2520%255B12.0%252C%252011.0%255D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2522modifiers%2522%253A%2520%255B%257B%2520%2522name%2522%253A%2520%2522mu%2522%252C%2520%2522data%2522%253A%2520null%252C%2520%2522type%2522%253A%2520%2522normfactor%2522%2520%257D%255D%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2522name%2522%253A%2520%2522bkg%2522%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2522data%2522%253A%2520%255B50.0%252C%252052.0%255D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2522modifiers%2522%253A%2520%255B%257B%2520%2522name%2522%253A%2520%2522uncorr_bkguncrt%2522%252C%2520%2522data%2522%253A%2520%255B3.0%252C%25207.0%255D%252C%2520%2522type%2522%253A%2520%2522shapesys%2522%2520%257D%255D%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257D%250A%2520%2520%2520%2520%2520%2520%2520%2520%255D%250A%2520%2520%2520%2520%257D%255D%252C%250A%2520%2520%2520%2520%2522data%2522%253A%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2522singlechannel%2522%253A%2520%255B51.0%252C%252048.0%255D%250A%2520%2520%2520%2520%257D%252C%250A%2520%2520%2520%2520%2522toplvl%2522%253A%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2522measurements%2522%253A%2520%255B%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2522config%2522%253A%2520%257B%2520%2522poi%2522%253A%2520%2522mu%2522%2520%257D%252C%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2522name%2522%253A%2520%2522singlechannel%2522%250A%2520%2520%2520%2520%2520%2520%2520%2520%257D%255D%250A%2520%2520%2520%2520%257D%250A%257D&es=2x&wm=false&ts=false">`JSON` defining a single channel, two bin counting experiment with systematics</a>

.center.width-100[![demo_JSON](figures/demo_json.svg)]

---

# $CL_{s}$ Example using `pyhf` CLI

<br>

```
$ pyhf cls demo.json
{
    "CLs_exp": [
        0.002606408505279359,
        0.013820656047622592,
        0.0644552079856191,
        0.23526102499555396,
        0.573041803728844
    ],
    "CLs_obs": 0.05290116065118097
}
```

---

# $CL_{s}$ with Reinterpretation

.bold[Original]

```
$ pyhf cls demo.json | jq .CLs_obs
0.05290116065118097
```

.bold[Consider a new signal to test]

```json
# new_signal.json
[{
    "op": "replace",
    "path": "/channels/0/samples/0/data",
    "value": [5.0, 6.0]
}]
```

.bold[Apply the patch with the new signal to update the likelihood]: $L \to L'$
```
$ pyhf cls demo.json --patch new_signal.json | jq .CLs_obs
0.3401578753020146
```

---

# _Preliminary_ Benchmarking

<br>

.grid[
.kol-1-2[

- Changing with many updates
- For a single channel with $n$ nuisance parameters already seeing performance boosts
- For many channels ROOT is still faster
- Needs to be revisited with recent updates that properly .bold[implement vectorization] and graph structure
   - Seeing over a $100x$ speedup to that seen in image
- Still need to benchmark on GPUs
   - Expect over a $10x$ speedup

]
.kol-1-2[
.width-100[![single_channel_benchmark](figures/benchmark_times.png)]

_old benchmark_: Single channel fit with $n$ bins (uncorrelated nuisance parameters) with CPU backends. Lower is better.
]
]

---

# Development

<br>

.center.width-100[![GitHub_awesome](figures/GitHub_banner.png)]

<!-- <br> -->

.grid[
.kol-1-2[

- Openly [developed on GitHub](https://github.com/diana-hep/pyhf)
- Looking for more users
- [Contributions welcome](https://github.com/diana-hep/pyhf/blob/master/CONTRIBUTING.md)!
   - Just a PR away 😉

]
.kol-1-2[
.width-100[![GitHub_awesome](figures/GitHub_awesome.png)]
]
]
Upcoming:
- Finish vectorization and GPU support
- Add a bridge that wraps the `pyhf` p.d.f. as a `RooAbsPdf`

---

# Summary

- Developed the first non-ROOT implementation of the HistFactory p.d.f. template
   - Core in pure Python: utilizing standard NumPy and SciPy stack
   - Deep learning frameworks for computational backends to leverage native autograd and GPU acceleration
   - Simple but powerful Pythonic API
- JSON specification
   - Fully describe model with single simple text based (versionable) file
   - Human and machine readable
   - Robust long long term support
- In the process of validating against ATLAS results
   - multibjet analysis and others
- Contributions welcome
   - [GitHub](https://github.com/diana-hep/pyhf)
   - [docs](https://diana-hep.org/pyhf/)

---

# References

1. ROOT collaboration, K. Cranmer, G. Lewis, L. Moneta, A. Shibata and W. Verkerke, .italic[[HistFactory: A tool for creating statistical models for use with RooFit and RooStats](http://inspirehep.net/record/1236448)], 2012.

---

class: end-slide, center
count: false

The end.
