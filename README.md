<img src="uth_logo_eng.png" style="width:20.0%" alt="image" />

UNIVERSITY OF THESSALY .5cm SCHOOL OF ENGINEERING .5cm DEPARTMENT OF
ELECTRICAL AND COMPUTER ENGINEERING TIME DOMAIN INDEX MODULATION (IM) IN
A DIGITAL .2cm COMMUNICATION SYSTEM

Zervos Spiridon  
spiridonzervos@gmail.com

# Time domain Index Modulation (IM) in a residual carrier digital communication system

**Abstract**  
The wireless network of today is the result of constantly increasing
demands in the area of wireless communication. It’s value is visible at
both an individual and a societal level and can be noticed by the rate
of usage as well as from the new needs that arise from it. Whereas
wireless technology is evolving at an ever growing pace, it’s progress
is slowly coming at a halt due to the spectrum crunch, all the while
demanding new technologies such as the Internet of Things, is pressing
for ever larger rates and quantities in wireless transmissions. To
tackle this obstacle, new techniques have been introduced to the status
quo, one of which being the scheme of Index Modulation (IM). IM provides
additional information by introducing activation states to the
communication medium, thus offering a variety of integration methods. In
the scope of this study, we focus on Time slot Index Modulation applied
on a SISO (single-input single-output) wireless communication channel
between transmitter and receiver. Furthermore, a residual carrier is
used for transmitting the data signal, as well as a Phase-Locked Loop
component by the receiver to undo the channel’s attenuation. Last but
not least, the results of the experiment are presented and comparisons
are made between the proposed scheme and currently used ones.

# CHAPTER 1: INTRODUCTION

With the advancement of technology, wireless transmission has become a
key component in human activity and daily life. Mobile phones, WiFi and
signal transmissions in general are prime examples of applied wireless
techniques. Moreover, advancements in both hardware and software
technologies, have further integrated said techniques as a basis of many
applications ,, the most recent of them being the Internet of Things
(IoT) , which will further increase the demand for higher data rates and
sizes.  
The need for bigger quantities in data sizes and higher transmission
speeds in combination with the limitations imposed by the spectrum
crunch phenomenon has led to new techniques and methods in wireless
communication to tackle such issues. The wide range of these new methods
offer promising results with reduced bandwidth requirements. As an
example, in , the authors insert the term Heterogeneous Networks
(HetNets) which offer increased capabilities due to better spectrum
management than the microwave based networks that are currently used. In
, a Light Fidelity (LiFi) system is established for the creation of a
wireless network; LED and LDs are used as transmitters and receivers,
thus using the optical spectrum for transmission.  
Other techniques focus on achieving the specifications of IoT. The
authors of , state that OFDM, a modulation scheme extensively used in
most modern-day applications, cannot fully meet the requirements of 5G.
This is further backed up in , where modifications of the OFDM scheme
lead to reduced overall errors in the transmission sessions. In , with
the usage of Reconfigurable Intelligent Surfaces (RIS) as a basis for
the transmission scheme, higher data rates were achieved, while it was
also stated that they could be integrated in beyond MIMO (multiple-input
multiple-output) topologies.  

## 1.1 Index Modulation

In the context of new methods and techniques developed for wireless
communication, the scheme of Index Modulation (IM) is proposed. IM has
been the subject of an increasing amount of studies over the years due
to it’s positive results in it’s various applications, especially in
achieving the demands of 5G networks ; this stems from the fact that the
IM scheme encodes information within the states of the transmission
medium. In addition, since it’s integration alters the physical layer
(PHY) of the OSI layer stack, it can be used in conjunction with other
modulations, further increasing their robustness.

## 1.2 Literature Review

The encoding of information in the medium of the transmission, as well
as the freedom to implement IM with other modulations, offer a great
amount of flexibility in it’s applications. Depending on the
requirements of each transmission scenario, the appropriate medium is
selected. The variability in the choice of the medium has lead to
various IM schemes such as Spatial Modulation (SM) in MIMO systems
taking advantage of the multi-channel nature of the topology, OFDM-IM
where additional information is encoded in the sub-carriers of the
transmission, Τime slot IM where the transmission time is divided into
time slots which are then used for the additional information. The
flexibility in IM’s application offers adaptability depending on the
demands, resulting in different schemes or hybrid ones with positive
results presented in , , , , .  
In addition, according to the authors of , IM is a subclass of the
Permutation Modulation (PM) introduced by Slepian D. in . According to
PM, a permutation vector is used by the transmitter (TX), which defines
the alphabet of the modulation; the receiver (RX) then can decode the
information based on the alphabet. In IM, the permutation vector regards
the state activation of the medium that is chosen.

## 1.3 Purpose of Dissertation

As it was mentioned above, IM has a vast amount of flexibility in it’s
application and thus a variety of studies have used it as a key
component. Since, MIMO systems are the principle of today’s wireless
transmission systems, as they take advantage of the multi-channel nature
of the wireless equipment , IM’s applications focus on this nature in
combination with the OFDM scheme. On the other hand, where a different
approach is introduced, IM’s application greatly alters the TX-RX model
of communication. In this dissertation we focus on the scheme of Time
slot Index Modulation in a SISO system. Furthermore, a single residual
carrier signal is used, as well as a Phase-Locked Loop (PLL) component
to undo the channel’s attenuation on the transmitted signal.

## 1.4 Dissertation Structure

The present dissertation is divided into seven chapters. In chapters
[2](#ch:2) through [4](#ch:4), the main components of the model are
introduced and analysed; in [Chapter 2](#ch:2), TX as well as the
application of Time slot Index Modulation scheme is studied. [Chapter
3](#ch:3) examines the transmission channel and it’s effects on the
transmitted information signal, while the RX of our model is introduced
in [Chapter 4](#ch:4) alongside with the effects of Time slot Index
Modulation on the reception of the signal. In [Chapter 5](#ch:5), the
model’s topology is presented as well as the algorithms that were
developed for each component, including the calculation of the Bit Error
Rate (BER). The results of the study are shown in [Chapter 6](#ch:6) for
different Signal-to-Noise Ratio (SNR) and Carrier-to-Noise Ratio (CNR)
values. Lastly, in [Chapter 7](#ch:7), we summarize the results and
mention prospects for future studies.

# CHAPTER 2: TRANSMITTER

## 2.1 TX Topology

In this chapter, the transmitter’s topology is presented and then
analyzed in it’s respective components. TX’s topology is displayed in
[Figure 1](#sch:1):

<figure id="sch:1">
<img src="tx.png" style="width:90.0%" />
<figcaption>TX component.</figcaption>
</figure>

## 2.2 Data Configuration

Digital information in the form of bits contains the useful information
that needs to be transmitted from the TX of the system to the
appropriate receiver. Since the information in it’s current form cannot
be transmitted, the signal needs to be subjected to various steps in
order to become transmittable. These processes have a direct impact on
the produced signal’s properties, thus rendering them invaluable for a
successful communication. Firstly, the digital information *b*(*t*), in
the form of bits, is subjected to the selected modulation scheme.
Modulating a bit-stream has as a result a sequence of complex numbers
which are also referred to as symbols. This happens by matching the bit
with the appropriate symbol based on the constellation diagram of the
modulation. The diagram of each modulation is defined by the alphabet
*M* of the modulation which also impacts the data size transferred and
the noise resistance of the signal. The modulation stage completes with
the symbol encoder resulting in the symbol signal *s*(*t*). In this
study, the Binary Phase Shift Keying (BPSK) modulation is used, the
constellation diagram of which is presented in [Figure 2](#sch:2).
BPSK’s constellation diagram consists of two symbols placed on the real
x axis.

<figure id="sch:2">
<img src="constellations.png" />
<figcaption>BPSK, QAM and 16-QAM Constellation Diagrams.</figcaption>
</figure>

## 2.3 Residual Carrier Signal

Alongside with the information signal, TX also transmits a carrier
signal *c*(*t*). Since attributes such as the amplitude *a*, phase
*ϕ*<sub>*c*</sub> and the frequency of the carrier *f*<sub>*c*</sub> are
predetermined, *c*(*t*)’s value is given for every *t*. The carrier
signal is described by the following equation:

*c*(*t*) = *a*sin (2*π**f*<sub>*c*</sub>*t*+*ϕ*<sub>*c*</sub>)

Since *c*(*t*)’s attributes can be predefined, by applying *c*(*t*) to
the information signal one can bring the latter to a form appropriate
for transmission. Based on the modulation scheme, the application of the
carrier differs. In BPSK, the information for transmission alters the
phase of the carrier *ϕ*<sub>*c*</sub>. In this study we apply a
non-return to zero (NRZ) BPSK. The equation of the passband signal given
by the application of the carrier signal of
(<a href="#eq:1" data-reference-type="ref"
data-reference="eq:1">[eq:1]</a>) is:

*s*(*t*) = *a*sin (2*π**f*<sub>*c*</sub>*t*+*ϕ*(*t*))

With a time variant phase *ϕ*(*t*). Expanding the sine term in
(<a href="#eq:2" data-reference-type="ref"
data-reference="eq:2">[eq:2]</a>) gives:

*s*(*t*) = *a*cos (*ϕ*(*t*))sin (2*π**f*<sub>*c*</sub>*t*) + *a*sin (*ϕ*(*t*))cos (2*π**f*<sub>*c*</sub>*t*)

Since we use NRZ BPSK the following are true *c**o**s*(*ϕ*(*t*)) = 1 and
*s**i**n*(*ϕ*(*t*)) = *ϕ*(*t*), thus
(<a href="#eq:3" data-reference-type="ref"
data-reference="eq:3">[eq:3]</a>) becomes:

*s*(*t*) = *a*sin (2*π**f*<sub>*c*</sub>*t*) + *a**ϕ*(*t*)cos (2*π**f*<sub>*c*</sub>*t*)

In (<a href="#eq:4" data-reference-type="ref"
data-reference="eq:4">[eq:4]</a>), the sine term describes the carrier
signal whereas the cosine term describes the information signal. Using
the mixer of [Figure 1](#sch:1), we apply
*e*<sup>−*j*2*π**f*<sub>*c*</sub>*t*</sup> to
(<a href="#eq:4" data-reference-type="ref"
data-reference="eq:4">[eq:4]</a>) and we get the baseband signal
*x*(*t*):

$$\begin{aligned}
\label{eq:5}
  s (t) e^{- j 2 \pi f_c t} & \Rightarrow & x (t) = a e^{j \phi (t)}
\end{aligned}$$

Since the upkeep of information for transmission is not constant, there
will be times where TX will not have any useful information to transmit
(since we apply Time slot IM these occurrences will be further
increased). TX can then choose between either ceasing transmission or
transmit trivial information. In this study the latter technique is used
by continuing the transmission of the carrier of
(<a href="#eq:1" data-reference-type="ref"
data-reference="eq:1">[eq:1]</a>). As a result, *c*(*t*) is classified
as a residual carrier, whereas in the opposite situation (where no
carrier is transmitted) it would have been classified as suppressed.

## 2.4 Index Modulation

Before the signal’s transmission, Time slot IM is applied to it at the
IM component’s stage. During this stage, the transmission times are
viewed as time slots which can be classified as activated on whether TX
decides to transmit or not. A time slot where a transmission occurs is
defined as an active time slot, whereas one where no useful information
is transmitted is defined as an inactive time slot. Useful information
refers to the contents of the message and not carrier signals. Values
can be assigned to the time slots to denote their active status such as
a value of $"1"$ for active time slots and $"0"$ for inactive ones.
Interpreting the sequence of the active-inactive time slots results in
additional information transmitted with benefits such as lower power
consumption or bandwidth usage which lead to faster transmission times.
Using BPSK with a symbol sequence of \[1 -1 -1 1 1 ...\], TX can cease
transmission for negative values. By using the aforementioned time slot
values, a time slot activation sequence of \[1 0 0 1 1 ...\] occurs. TX
will then transmit the $"1"$ valued symbols, otherwise ceasing it’s
transmission, RX will deduct the $"-1"$ valued ones which ultimately
reduces the overall power consumption of the transmission scheme. From
the above, one can easily deduce that the concept regarding the
symbols-time slots sequencing can be modified to transfer additional
information by matching the two sequences. An example of such a
modification using BPSK, a symbol sequence
*s*\[*n*\] = \[1−111−1−11−1...\] and symbol-to-time slot sequence
matching following the previous notation with matches
\[−1−1\] → \[00\], \[−11\] → \[01\], \[1−1\] → \[10\] is presented
bellow. TX using the matchings as a lookup table will shape it’s time
slot activation pattern as such:

|  i  | symbol-to-transfer | following-symbol | ts activation |
|:---:|:------------------:|:----------------:|:-------------:|
| 1\. |       \[1\]        |      \[-1\]      |    \[1 0\]    |
| 2\. |       \[1\]        |      \[1\]       |    \[1 1\]    |
| 3\. |       \[-1\]       |      \[-1\]      |    \[0 0\]    |
| 4\. |       \[1\]        |      \[-1\]      |    \[1 0\]    |
| 5\. |        ...         |       ...        |      ...      |

Table of symbol-to-time slot sequence matching.

The produced activation sequence is given by the *t**s*
*a**c**t**i**v**a**t**i**o**n* column and is equal to \[10110010...\].

|  i  | ts activation | transferred symbol(s) | received symbols | deducted symbols |
|:---:|:-------------:|:---------------------:|:----------------:|:----------------:|
| 1\. |    \[1 0\]    |         \[1\]         |      \[1\]       |      \[-1\]      |
| 2\. |    \[1 1\]    |        \[1 1\]        |     \[1 1\]      |        –         |
| 3\. |    \[0 0\]    |           –           |        –         |    \[-1 -1\]     |
| 4\. |    \[1 0\]    |         \[1\]         |      \[1 \]      |      \[-1\]      |
| 5\. |      ...      |          ...          |       ...        |       ...        |

TX-RX communication with Time slot IM.

From the previous example it is shown that it is possible to further
increase the additional information encoded in the activation patterns
by increasing the group size of the time slots. Instead, in this study,
we focus on the overall effect that the Time slot IM has on the
transmission noise and error wise, thus no further study is done on
these parts. The central idea of the study is shown in [Figure
3](#sch:x):

<figure id="sch:x">
<img src="TIM.png" />
<figcaption>Transmission with Time slot IM.</figcaption>
</figure>

# CHAPTER 3: COMMUNICATION CHANNEL

At this point *x*<sub>*I*</sub>*M*(*t*) is transmitted in the form of
electromagnetic energy. The medium in which the transmission takes place
is characterized as a communication channel shown in [Figure 4](#sch:3).
The channel in the form of a filter attenuates *x*<sub>*I**M*</sub>(*t*)
producing the signal *y*(*t*). Since the study uses the natural
environment as the communication channel, the signal passing through it
has it’s values altered due to the channel’s impulse response, as well
as the various processes taking place in the environment.

<figure id="sch:3">
<img src="channel.png" />
<figcaption>Transmission channel between TX and RX.</figcaption>
</figure>

## 3.1 Modelling the Channel as a Filter

The communication channel is modeled as a filter *h*(*t*) through which
the signal passes. The transfer function of the filter, *H*(*f*),
provides it’s impulse response (IR) *h*. Applying it to
*x*<sub>*I**M*</sub>(*t*), the resulted signal is given by the
convolution of the two:

*x*<sub>*I**M*</sub>′(*t*) = *h*(*t*) \* *x*<sub>*I**M*</sub>(*t*)

where

*h*(*t*) \* *x*<sub>*I**M*</sub>(*t*) = ∫<sub>−∞</sub><sup>∞</sup>*h*(*τ*)*x*<sub>*I**M*</sub>(*t*−*τ*)*d**τ*

The components dictating the nature of the environment shape it’s
mathematic model. The physical distance between TX and RX results in a
delay between transmission and reception called propagation delay. The
electromagnetic energy that bounces off in surfaces existing in the
transmission’s environment cause additional signals to be received by RX
leading to Intersymbol Interference (ISI) explained in [Figure
5](#sch:4):

<figure id="sch:4">
<img src="ir.png" />
<figcaption>ISI.</figcaption>
</figure>

Additional to the Line of Sight (LOS) displayed as a black line which
shows the direct path between TX-RX, multiple signals are being received
due to the initial signal bouncing off surfaces of the environment.
These additional signals have altered attributes and are described in
(<a href="#eq:7" data-reference-type="ref"
data-reference="eq:7">[eq:7]</a>):

*h*(*t*) = ∑<sub>*i*</sub>*a*<sub>*i*</sub>cos (2*π**f*<sub>*c*</sub>*t*+*ϕ*<sub>*i*</sub>(*t*))

with *i* = 1, 2, ... the multiple instances of the signals,
*a*<sub>*i*</sub> the altered amplitude of each signal and
*p**h**i*<sub>*i*</sub>(*t*) their phase. Expanding the cosine term in
(<a href="#eq:7" data-reference-type="ref"
data-reference="eq:7">[eq:7]</a>) we get:

$$\begin{aligned}
\label{eq:8}
    (\ref{eq:7}) & = \sum_i \[a_i \cos (\phi_i (t)) \cos (2 \pi f_c t)\] - \sum_i \[a_i \sin
   (\phi_i (t)) \sin (2 \pi f_c t)\]\notag\\
   & = \sum_i a_i \cos (\phi_i (t)) \cos (2 \pi f_c t) - \sum_i a_i \sin (\phi_i
   (t)) \sin (2 \pi f_c t)\notag\\
   & = r_i (t) \cos (2 \pi f_c t) - r_q (t) \sin (2 \pi f_c t)
\end{aligned}$$

where *r*<sub>*i*</sub>(*t*) and *r*<sub>*q*</sub>(*t*) are the sums of
random variables with equal PDFs. Using the Central Limit Theorem (CLT),
*r*<sub>*i*</sub>(*t*) and *r*<sub>*q*</sub>(*t*) are Gaussian random
variables:

*h*(*t*) = *r*<sub>*i*</sub>(*t*) + *j**r*<sub>*q*</sub>(*t*)

Since *h*(*t*) is a complex number, by converting it to it’s polar
coordinates we receive the following form:

$$\begin{aligned}
\label{eq:10}
  h (\theta) = \|h\| \angle \theta, & where & \theta =
  \tan^{- 1} \left( \frac{r_q}{r_i} \right)
\end{aligned}$$

Using (<a href="#eq:6" data-reference-type="ref"
data-reference="eq:6">[eq:6]</a>) we can apply the channel’s *h*(*t*) to
a symbol *x* = *a* + *j**b* ⇒ *x* = \|*x*\|∠*ϕ* resulting to the
filtered version of the symbol:

*x*′ = *h*<sub>1</sub>*x* = \|*h*<sub>1</sub>\|\|*x*\|∠(*θ*<sub>1</sub>+*ϕ*)

From (<a href="#eq:11" data-reference-type="ref"
data-reference="eq:11">[eq:11]</a>) it is now obvious how the channel
alters the signal through the application of *h* on the symbols. Due to
the channel being the natural environment the following holds
\|*h*\| \< 1. This reduces the filtered symbol’s amplitude and can be
perceived as a reduction to the vector’s magnitude. Secondly, IR’s phase
alters the phase of the symbol, which translates to a rotation of the
symbol.

## 3.2 Additive White Gaussian Noise

Another aspect of the channel that further affects the signal’s
transmission is the noise that exists in said channel. Noise is the
result of multiple other processes happening in the same environment as
the transmission. There is a plethora of mathematical models for noise
simulation, but in this study the Additive White Gaussian Noise (AWGN)
model is followed. AWGN has *P**S**D* = *N*<sub>0</sub>
*W**a**t**t*/*H**z*, is added to the signal and follows a normal
distribution with zero mean value. Taking the above into account,
(<a href="#eq:6" data-reference-type="ref"
data-reference="eq:6">[eq:6]</a>) becomes:

*y*(*t*) = *x*<sub>*I**M*</sub>′(*t*) + *n*(*t*) = *h*(*t*) \* *x*<sub>*I**M*</sub>(*t*) + *n*(*t*)

Where *n*(*t*) is the AWGN function, and the channel of [Figure
4](#sch:3) is now further analysed into [Figure 6](#sch:3.2).

<figure id="sch:3.2">
<img src="channel2.png" />
<figcaption>Channel analysis.</figcaption>
</figure>

At this point, the symbols received by RX will have the following form:

*y*<sub>1</sub> = *x*′ + *n*<sub>1</sub> = *h*<sub>1</sub>*x* + *n*<sub>1</sub> = \|*h*<sub>1</sub>\|\|*x*\|∠(*θ*<sub>1</sub>+*ϕ*) + *n*<sub>1</sub>

In the value of the already rotated and with reduced amplitude symbols,
the value of the noise signal is added contributing to even higher
attenuation. All of the above show the importance of the channel’s state
and how it affects the transmitted signal as it directly impacts the
number of errors in it’s reception.

# CHAPTER 4: RECEIVER

## 4.1 Data Reception

Due to the factors described in [Chapter 3](#ch:3), RX must submit the
received signal to certain stages to undo the attenuation affecting it.
RX follows the stages pictured in [Figure 7](#sch:5).

<figure id="sch:5">
<img src="rx.png" />
<figcaption>RX component.</figcaption>
</figure>

## 4.2 Phase Detection

In order to undo the changes made to the signal, we must further analyse
the way it is affected by the channel. The discreet representation of
(<a href="#eq:12" data-reference-type="ref"
data-reference="eq:12">[eq:12]</a>) is:

*y*\[*n*\] = *h*\[*n*\] \* *x*<sub>*I**M*</sub>\[*n*\] + *n*\[*n*\]

By viewing *y*\[*n*\] as a vector equal to the multiplication of the
table *H*, containing the channel’s taps, with the vector
*x*<sub>*I**M*</sub>, containing the values of
*x*<sub>*I**M*</sub>\[*n*\] for every *n*, adding the noise vector *n*
we get the equation:

*y* = *H**x*<sub>*I**M*</sub> + *n*

Since a SISO approach is used in this study, the IR will have a singular
tap value throughout the communication, thus *H* is a vector *h*,
(<a href="#eq:13" data-reference-type="ref"
data-reference="eq:13">[eq:13]</a>) then becomes:

*y* = *h**x*<sub>*I**M*</sub> + *n*

where undoing *h* is described as:

$$\label{eq:16}
  \hat{y} = \frac{1}{\|h\|} \angle(y\_{angle} - \theta)$$

From (<a href="#eq:15" data-reference-type="ref"
data-reference="eq:15">[eq:15]</a>) and
(<a href="#eq:16" data-reference-type="ref"
data-reference="eq:16">[eq:16]</a>), it is obvious that undoing the
effects of the channel’s IR is equal to undoing the amplitude and phase
of *h*. Due to the complexity of calculating an approximation for the
IR’s amplitude, we focus on the calculation of *h*’s phase. This is
achieved by using a Phase-Locked Loop component at the RX’s reception.

## 4.3 Phase-Locked Loop

The Phase-Locked Loop (PLL) is described in [Figure 8](#sch:6), where
the received signal enters the first stage of the PLL. The approximation
of the IR’s phase *θ̂*(*t*) is achieved using the differentiations in
*y*(*t*)’s values.

<figure id="sch:6">
<img src="pll.jpg" />
<figcaption>Stages of a PLL.</figcaption>
</figure>

### 4.3.1 Phase Detector

In this stage, an approximation error *ϵ*(*t*) of the channel’s phase is
calculated during each iteration using *y*(*t*)’s phase *θ*(*t*) and the
channel’s phase approximation of the previous iteration *θ̂*(*t*). The
error is equal to *ϵ*(*t*) = *θ*(*t*) − *θ̂*(*t*) and thus
*ϵ*(*t*) → 0 ⇒ *θ̂*(*t*) → *θ*(*t*), resulting in a better approximation.

<figure id="sch:7">
<img src="phasedetector.png" />
<figcaption>Phase Detector.</figcaption>
</figure>

As shown in [Figure 9](#sch:7), the passband signal *y*(*t*) can be
described as *e*<sup>*j**θ*</sup> + *n*(*t*), where *e*<sup>*j**θ*</sup>
is the phase of the information *ϕ* signal altered from the channel’s
ir. Since the phase of the symbols is predetermined by the modulation
scheme used, using the Adder component of the phase detector, we can
omit *ϕ* and thus isolate *θ̂*. Eradicating the symbol’s phase is
achieved by taking advantage of the correlation between each symbol’s
phase. In BPSK, as shown in [Figure 2](#sch:2), since the two symbols
comprising the constellation diagram have phase equal to 0 or *π*, the
correlation between the two is *π* rads, which leads to:

$$\begin{aligned}
    & \theta\_{pi} = \theta\_{0} + \pi \notag\\
    & 2 \theta\_{pi} = 2 \theta\_{0} + 2 \pi \notag\\
    & \sin(2 \theta\_{pi}) = \sin(2 \theta\_{0} + 2 \pi) = \sin(2 \theta\_{0}) \notag
\end{aligned}$$

The symbol phase convergence described above is schematically explained
in [Figure 10](#sch:8) where a singular tap *h* equal to
$-\frac{\pi}{6}$ was used and it can be similarly applied for any phase:

<figure id="sch:8">
<img src="angles.png" />
<figcaption>BPSK symbol phase convergence.</figcaption>
</figure>

Furthermore, multiplying the symbol’s phase by 2 leads to their
convergence to a singular value, which then can be redacted without the
explicit knowledge of it’s value. For this to hold true, they need to
converge to a positive quadrant for the correct approximation of *h*.
The value chosen for the multiplication of the phase is inseparably
linked with the modulation scheme applied and it’s alphabet. Based on
the alphabet of the modulation the same value of multiplications need to
be made. As an example, symbol phase convergence for QAM is shown in
[Figure 11](#sch:9):

<figure id="sch:9">
<img src="angleQAM.jpg" style="width:70.0%" />
<figcaption>QAM symbol phase convergence.</figcaption>
</figure>

Since the phase converged in a negative quadrant, appropriate actions
need to be made for a correct result. These are explained in [Chapter
5](#algo:5) and are described schematically as the *f* component of the
phase detector in [Figure 9](#sch:7).

### 4.3.2 Loop Filter

After calculating the error, this enters the loop filter stage. The
basic attributes of the loop filter *L*(*s*) are defined in this stage.
Depending on *L*(*s*) we have:

*L*(*s*) = *K*<sub>*L*</sub> = *c**o**n**s**t**a**n**t*

The PLL is classified as a first order PLL, with transfer function:

$$H (s) = \frac{K_L}{K_L + s}$$

The simplicity of the first order PLL renders it susceptible to noise
since it has no component for filtering it. If the loop filter is
described by the following function:

$$\label{eq:17}
  L (s) = K_L \frac{a + s}{b + s}$$

The PLL is classified as a second order PLL. Setting *b* = 0 results in:

$$\label{eq:18}
  L (s) = K_L \frac{a + s}{s} = K_L + K_L \frac{a}{s}$$

Making it a PI (proportional-integral) loop filter as it is comprised of
an integrator proportional to the input *K*<sub>*p*</sub> and an
integrator proportional to the integral of the input *K*<sub>*i*</sub>.
The transfer function of a second order PI PLL is equal to:

$$\label{eq:19}
  H (s) = \frac{K_L a + K_L s}{K_L a + K_L s + s^2}$$

The first parameter that we will analyse, is the damping factor *ζ* of
the PLL:

$$\label{eq:20}
  \zeta = \frac{1}{2}  \sqrt{\frac{K_L}{a}}$$

*ζ* defines the range of values of the approximation *θ̂*(*t*) until it
converges. Depending on *ζ* the following cases occur:

-   *ζ* \< 1 the system is underdamped, showing a wide range of values
    for *θ̂*(*t*)

-   *ζ* = 1 the system is critically damped, offering a tighter range of
    values

-   *ζ* \> 1 the system is overdamped, offering the tightest range of
    values

The next parameter is the natural frequency *w*<sub>*n*</sub> of the
PLL:

$$\label{eq:21}
  w_n = \sqrt{K_L a}$$

*w*<sub>*n*</sub> affects the loop bandwidth of the PLL and more
specifically the noise bandwidth *B*<sub>*L*</sub> which comprises the
PLL’s low-pass filter:

$$\label{eq:22}
    B_L = \frac{w_n}{2}  \left( \zeta + \frac{1}{4 \zeta} \right)$$

Selecting the appropriate *B*<sub>*L*</sub> value differs in each
application since the following trade-off occurs. A small noise
bandwidth value leads to more noise filtered which also leads to
filtering frequencies useful for the phase approximation thus converging
to a value slower compared to a PLL with a bigger *B*<sub>*L*</sub>
value. In addition, a bigger bandwidth value leads to a noisy phase
approximation. Due to the importance of the noise bandwidth value to the
PLL’s efficiency, we give an appropriate value to *B*<sub>*L*</sub>
first and then to *ζ* and *w*<sub>*n*</sub> as they are directly
correlated to it’s value. From
(<a href="#eq:20" data-reference-type="ref"
data-reference="eq:20">[eq:20]</a>),
(<a href="#eq:21" data-reference-type="ref"
data-reference="eq:21">[eq:21]</a>),
(<a href="#eq:22" data-reference-type="ref"
data-reference="eq:22">[eq:22]</a>) a second order PLL (which is also
used in this study) has a transfer function of:

$$\label{eq:23}
    H (s) = \frac{w_n^2 + 2 \zeta w_n s}{w_n^2 + 2 \zeta w_n s + s^2}$$

(<a href="#eq:23" data-reference-type="ref"
data-reference="eq:23">[eq:23]</a>) shows how the aforementioned
parameters directly define the PLL’s operation. Also, *K*<sub>*i*</sub>
and *K*<sub>*p*</sub> directly affect the loop filter, since:

-   *(proportional)*
    *K*<sub>*p*</sub> = 2*ζ**w*<sub>*n*</sub>*T*<sub>*s*</sub>, where
    *T*<sub>*s*</sub> the sampling frequency

-   *(integral)*
    *K*<sub>*i*</sub> = *w*<sub>*n*</sub><sup>2</sup>*T*<sub>*s*</sub><sup>2</sup>

After the stage of the loop filter, *ϵ*(*t*), produces a control signal
*c*(*t*) which is then used in the stage of the Voltage Controlled
Oscillator.

### 4.3.3 Voltage Controlled Oscillator

The final stage of the PLL consists of a voltage controlled oscillator
(VCO) whose phase can be altered based on the input signal. VCO’s input
is the control signal *c*(*t*) calculated in the previous stage;
depending on *c*(*t*)’s amplitude, VCO’s phase is altered accordingly.
The control signal alongside with the angular frequency of the VCO are
used to calculate *θ̂*:

$$w = \frac{d (2 \pi f_c t + \widehat \theta(t) )}{dt}$$
$$= 2 \pi f_c + \frac{d \widehat \theta(t) }{dt}$$
with $\frac{d \widehat \theta(t)}{dt} = c (t)$:
*w* = 2*π**f*<sub>*c*</sub> + *c*(*t*),  *θ̂*(*t*) = ∫<sub>−∞</sub><sup>*t*</sup>*c*(*τ*)*d**τ*

## 4.4 Index Modulation

At this stage, the RX must identify the nature of the time slot when the
reception was made, meaning the classification between an active and an
inactive time slot. Due to the transmission taking place in a natural
environment, time slots where no transmission from the TX is made, will
still contain information due to the noise of the channel as explained
previously. Thus we devise the stage of IM Detection, where based on the
signal’s power, it is identified as noise and discarded or as useful
information which then proceeds on to the stage of symbol demodulation.
Simultaneously, the additional information from the active states of the
time slots is matched to the correct values.

# CHAPTER 5: TOPOLOGY

The overall communication model described in the previous chapters is
displayed in [Figure 12](#sch:10). For the communication between TX and
RX a carrier signal is used forming the complex passband signal *x*(*t*)
to which Time slot IM is applied. The transmitted signal is filtered by
the channel’s impulse response leading to the received attenuated signal
*y*(*t*). By identifying the IR’s phase *θ̂* and the sequence of the
active-inactive sequence of the time slots, we get the output bitstream
*b*′(*t*).

<figure id="sch:10">
<img src="topology.png" />
<figcaption>The system’s complete topology.</figcaption>
</figure>

At this point, the topology followed in this study as well as the
theoretical background for each component’s function has been fully
analysed. The algorithms describing the system’s components used in this
study are analysed bellow.

## 5.1 TX Implementation

[Algorithm 1](#algo:1) describes the TX component of the communication
system. TX produces the symbol stream *s*, the carrier signal *c* as
well as the activation sequence of the time slots contained in
*x*<sub>*I**M*</sub> alongside with the symbols to be transmitted.

<span id="algo:1" label="algo:1"></span>
*s* = *B**P**S**K**M**o**d**u**l**a**t**i**o**n*(*b*,*M*)
*x*<sub>*I**M*</sub> = *T**i**m**e**S**l**o**t**I**n**d**e**x**M**o**d**u**l**a**t**i**o**n*(*s*)
*S**i**z**e**O**f*(*c**a**r**r**i**e**r*) = *S**i**z**e**O**f*(*x*<sub>*I**M*</sub>)
*c**a**r**r**i**e**r* = *a*

The implementation of Time slot Index Modulation in TX is shown in
[algorithm 2](#algo:2). The additional information transferred during
Time slot IM is based on the sequence of the time slots’ activation
states. In this study, we focus on a *random* sequence scheme decided by
TX so as to study the complete behavior of the scheme. The number of
time slots forming each group is 2, thus 2<sup>2</sup> cases. Following
the notation presented in [Chapter 1.4](#ch:1.4) the time slot cases
available are \[00  01  10  11\].

<span id="algo:2" label="algo:2"></span> *k*, *i* = 1

The values of *x*<sub>*I**M*</sub> will be equal to 0 for inactive time
slots and equal to the corresponding symbol value of the BPSK modulation
for active time slots both of which values are tampered with as the
signal is filtered through the channel.

## 5.2 Communication Channel Implementation

The communication channel algorithm is described in chapters
[6.1](#ch:6.2) and [6.2](#ch:6.3) where the difference between the AWGN
and Rician fading channel is analysed.

## 5.3 RX implementation

RX’s basic function is described in [algorithm 3](#algo:3).

<span id="algo:3" label="algo:3"></span>
*θ̂* = *P**L**L*(*B*<sub>*L*</sub>,*w*<sub>*n*</sub>,*ζ*,*y*)
*ŷ* = *y**e*<sup>−*j**θ̂*</sup>
*y*′ = *T**i**m**e**S**l**o**t**I**n**d**e**x**D**e**m**o**d**u**l**a**t**i**o**n*(*ŷ*)
*b*′ = *B**P**S**K**D**e**m**o**d**u**l**a**t**i**o**n*(*y*′,*M*)

The following algorithm comprises the PLL stage of the RX. The stage of
the phase detector, loop filter and VCO are separate functions part of
[algorithm 4](#algo:4). The resulting phase approximation *θ̂* is then
used for negating the IR’s phase.

<span id="algo:4" label="algo:4"></span> *n* = 2
*i**n**t**e**g**r**a**t**o**r* = 0
*S**i**z**e**O**f*(*θ̂*) = *S**i**z**e**O**f*(*y*) *θ̂* = 0
*S**i**z**e**O**f*(*c*) = *S**i**z**e**O**f*(*y*) *c* = 0
$w_n = \frac{2B_L}{\zeta + \frac{1}{4\zeta}}$
*K*<sub>*i*</sub> = *w*<sub>*n*</sub><sup>2</sup>*T*<sub>*s*</sub><sup>2</sup>
*K*<sub>*p*</sub> = 2*ζ**w*<sub>*n*</sub>*T*<sub>*s*</sub>

[Algorithm 5](#algo:5) describes the phase detector of [Chapter
4.3.1](#ch:4.3.1). It also shows the importance of a positive sine
value, as well as the suppression of the symbol’s phase.

<span id="algo:5" label="algo:5"></span>
*d**i**f**f* = *a**n**g**l**e*(*y*) − *θ̂*
*ϵ* = sin (−*s**i**g**n*(*j*<sup>*M*</sup>)⋅*M*⋅*d**i**f**f*)

By taking advantage of the carrier signal transmitted continuously by
the TX even in inactive time slots, we can further modify
(<a href="#algo:5" data-reference-type="ref"
data-reference="algo:5">[algo:5]</a>) resulting in a more accurate
calculation of the error *ϵ*. In
(<a href="#eq:4" data-reference-type="ref"
data-reference="eq:4">[eq:4]</a>), we can discern the term corresponding
to the carrier signal from the term containing the information signal
and regardless of it’s conversion to a passband signal, this variation
still stands. The carrier term shows smaller variations in it’s values
as opposed to the fast changing data term. Thus by focusing on the
carrier term we get better approximations regarding their accuracy.
Applying all of the above, we get:

<span id="algo:6" label="algo:6"></span>
*ϵ* = *a**n**g**l**e*(*y*) − *θ̂*

The PLL’s VCO of [Chapter 4.3.3](#ch:4.3.3) is outlined in [algorithm
7](#algo:7):

<span id="algo:7" label="algo:7"></span>
*θ*<sub>*n*</sub> = *θ*<sub>*n* − 1</sub> + *c*<sub>*n* − 1</sub>

Parallel to the approximation of the channel’s phase, the input signal
enters the stage of Time slot Index Demodulation. The resulting *y*′ is
free of inactive time slots and contains only the symbols transferred
during the active time slots:

<span id="algo:8" label="algo:8"></span> *i*, *j* = 1

Time slot Index Demodulator utilizes the Euclidean norm of each data
*y*<sub>*i*</sub> to classify it as noise or symbol. At this point we
also calculate the Bit Error Rate (BER) of the transmission. BER is
defined as:

$$\label{eq:24}
    BER = \frac{number\\of\\wrong\\bits}{number\\of\\total\\transmitted\\bits}$$

In Time slot IM, BER is modified to take into account the
miss-classification of the active-inactive time slots due to noise. BER
calculation in this case, focuses on:

-   The correct categorisation of the time slots/symbols.

-   The number of wrong bits from BPSK demodulation.

-   Addition of the above and division of the result with the sum of the
    time slots and the bits at the exit *b*′.

Thus (<a href="#eq:24" data-reference-type="ref"
data-reference="eq:24">[eq:24]</a>) becomes:

$$BER = \frac{number\\of\\wrong\\time\\slot\\classification + number\\of\\wrong\\bits}{number\\of\\total\\transmitted\\time\\slots + number\\of\\bits\\at\\output}$$

The above procedure respects the order of the bits, in this way they are
compared with their appropriate counterparts.

# CHAPTER 6: RESULTS

The algorithms presented above where coded in the Matlab environment of
Mathworks and the results are displayed bellow. Two cases where studied,
one where the channel is described as an AWGN only channel and thus it’s
impulse response has a singular value, constant for the duration of the
transmission. In the second one a rician channel is used where the
*L**O**S* effects mentioned in [Chapter 3.1](#ch:3.1) are applied,
meaning the value of *h* is changing based on the signal’s power and the
channel’s characteristics. For each case, different values of *S**N**R*
and *C**N**R* where used. Studying the behavior of the system based on
the *C**N**R* was deemed appropriate since it is directly used for the
phase approximation. The values *C**N**R* = 0, 10, 20*d**B* where used
and for each case *S**N**R* received values of  − 5, 0, 5, 10*d**B*. The
resulting BER is then compared to the BER of the transmission without
the application of Time slot IM, as well as a comparison between the
throughputs of the two schemes is made. Additionally, the throughput of
Time slot IM is governed by the fact that 1-bit additional information
can be transmitted due to the time slot sequencing.  

## 6.1 Results for AWGN Channel

[Algorithm 9](#algo:9) describes the steps taken for the simulation of
the AWGN channel and it’s effects on the transmitted signal:

<span id="algo:9" label="algo:9"></span> Set *h*<sub>0</sub>
*y* = *h*<sub>0</sub> ⋅ *x*<sub>*I**M*</sub>
*c*′ = *h*<sub>0</sub> ⋅ *c* Create AWGN channel *n*<sub>1</sub>
*y* = *n*<sub>1</sub>(*y*) Create AWGN channel *n*<sub>2</sub>
*c*′ = *n*<sub>2</sub>(*c*)

In [Figure 13](#sch:11), we can observe that the BER of Time slot IM
follows a slower pace of reduction compared to it’s counterpart, where
no IM schemes are applied. This is due to the fact that errors can occur
in the identification of the time slots.

<figure id="sch:11">
<img src="AWGNber.png" style="width:50.0%" />
<figcaption>BER of time slot IM versus no-IM for AWGN
channel..</figcaption>
</figure>

The throughput comparison in [Figure 14](#sch:12), confirms that Time
slot ΙΜ outweigh it’s counterpart due to the additional information that
is mentioned throughout the study.

<figure id="sch:12">
<img src="AWGNtput.png" style="width:50.0%" />
<figcaption>Throughput of time slot IM versus no-IM for AWGN
channel.</figcaption>
</figure>

Last but not least, in [Figure 15](#sch:13), the approximation of *θ̂* is
displayed. In this particular simulation, *h* = 1∠0 throughout the
transmission. *C**N**R* also directly affects the quality of the
approximation (cases of 0*d**B* and 10*d**B*) as hypothesised
previously, where it converges after a certain value (cases of 10*d**B*
and 20*d**B*).

<figure id="sch:13">
<img src="AWGN.phase.png" style="width:50.0%" />
<figcaption>Phase approximation for AWGN channel.</figcaption>
</figure>

## 6.2 Results for Rician Channel

[Algorithm 10](#algo:10) describes the steps taken for the simulation of
the rician channel and it’s effects on the transmitted signal with
notable differences with [Algorithm 9](#algo:9):

<span id="algo:10" label="algo:10"></span> Set *h*
*y* = *f**i**l**t**e**r*(*h*,*x*<sub>*I**M*</sub>)
*c*′ = *f**i**l**t**e**r*(*h*,*c*) Create AWGN channel *n*<sub>1</sub>
*y* = *n*<sub>1</sub>(*y*) Create AWGN channel *n*<sub>2</sub>
*c*′ = *n*<sub>2</sub>(*c*)

In [Figure 16](#sch:14), we can observe that the BER of Time slot IM
follows a slower pace of reduction compared to it’s counterpart, where
no IM schemes are applied. This is due to the fact that errors can occur
in the identification of the time slots, similar with [Figure
13](#sch:11).

<figure id="sch:14">
<img src="RICIANber.png" />
<figcaption>BER of time slot IM versus no-IM for Rician
channel.</figcaption>
</figure>

As in the AWGN case, the throughput comparison in [Figure 17](#sch:15),
again confirms that Time slot ΙΜ outweighs it’s counterpart due to the
additional information transmitted.

<figure id="sch:15">
<img src="RICIANtput.png" />
<figcaption>Throughput of time slot IM versus no-IM for Rician
channel.</figcaption>
</figure>

In the case of the rician channel, one can better understand the
accuracy of the PLL in calculating the approximation of the IR’s phase.
In [Figure 18](#sch:16), the approximation of *θ̂* is displayed. In this
particular simulation, *h* = 1∠0 throughout the transmission. *C**N**R*
also directly affects the quality of the approximation (cases of 0*d**B*
and 10*d**B*) as hypothesised previously, where it converges after a
certain value (cases of 10*d**B* and 20*d**B*).

<figure id="sch:16">
<img src="RICIANphase.png" />
<figcaption>Phase approximation for Rician channel.</figcaption>
</figure>

# CHAPTER 7: CONCLUSION

In this study, the Time slot IM scheme was applied in a SISO system of
wireless communication between TX-RX with a BPSK modulation scheme. The
SISO topology lead to the channel’s impulse response to be consisted of
a singular tap. The channel’s attenuation on the transmitted signal was
negated using a second order PI PLL at the RX, as well as the
identification of the active and inactive time slots by the RX.  
Taking into account the complete topology as well as the codependancies
between the functionalities of the system, we can discern the critical
points which can optimize it’s efficiency. The trade-off mentioned in
[Chapter 4.3.2](#ch:4.3.2) regarding the noise bandwidth of the PLL, the
reduced BER of the Time slot IM which leads to lower throughput as well
as the effect of the modulation used in the application, directly affect
the performance of the system’s components. Due to the different
alphabet of each modulation scheme, the robustness of the transmitted
signal varies in each application, thus research is required for the
effects between different types of modulations (QPSK, QAM, etc.) have in
combination with Time slot IM. Moreover, the study of Time slot IM can
be further expanded in multi-channel systems and MIMO topologies and how
transmissions from different antennas affect each other’s time slot
sequencing.
