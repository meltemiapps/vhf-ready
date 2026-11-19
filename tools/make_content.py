"""Generates VHFReady/Resources/Content/en/course.json and questions.json.
All wording is original to this project."""
import json, pathlib, sys

out = pathlib.Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=True)

H = lambda t: {"type": "heading", "text": t}
T = lambda t: {"type": "text", "text": t}
L = lambda *i: {"type": "list", "items": list(i)}
F = lambda title, body: {"type": "fact", "title": title, "body": body}
TIP = lambda t: {"type": "tip", "text": t}
W = lambda t: {"type": "warning", "text": t}
S = lambda *lines: {"type": "script", "lines": list(lines)}

def lesson(id, title, minutes, *blocks):
    return {"id": id, "title": title, "minutes": minutes, "blocks": list(blocks)}

modules = [
 {"id": "basics", "titleKey": "Radio basics & licensing", "symbol": "antenna.radiowaves.left.and.right", "lessons": [
  lesson("basics-1", "Who needs a qualification", 4,
   T("Marine VHF is a shared, regulated service. Anyone who transmits on it must hold an operator's certificate, and the radio installation itself must be licensed. The Short Range Certificate (SRC) is the operator qualification for VHF, including Digital Selective Calling (DSC)."),
   F("Two licences", "One covers the radio installation on the vessel. The other is your personal operator's certificate."),
   L("The ship radio licence covers the vessel's fixed and handheld radios, EPIRB and AIS, and it is where the vessel's call sign and MMSI come from.",
     "A licensed handheld kept for use on different boats can be covered by a separate portable licence.",
     "An unqualified person may transmit only under the direct supervision of a certificate holder, or in a genuine distress situation."),
   H("Your responsibilities"),
   L("The skipper (master) has overall authority over the station and its use.",
     "Secrecy of correspondence: you must not repeat or use anything you overhear that was not meant for you, except distress, urgency and safety traffic.",
     "No offensive language, no unnecessary or false transmissions, and never a hoax distress call.",
     "Marine VHF is for use at sea. Using it ashore, other than from licensed stations, is generally not allowed."),
   TIP("Rules differ slightly between countries. Always check the current requirements of the country where your vessel is registered.")),
  lesson("basics-2", "How VHF signals travel", 5,
   T("Marine VHF uses frequencies of roughly 156 to 174 MHz. At these frequencies signals travel in nearly straight lines, so range depends mainly on how high the two antennas are, not on transmitter power."),
   F("Line of sight", "Approximate range in nautical miles = 2.25 × (√ height A + √ height B), heights in metres."),
   T("Example: a yacht with an antenna 9 m above the water talking to another 9 m antenna gives about 2.25 × (3 + 3) = 13.5 nautical miles (about 25 km). A coast station antenna high on a cliff may be heard 30 nautical miles or more away."),
   L("Fixed radios transmit up to 25 watts. Use low power (1 watt) for short-range calls, such as in a marina.",
     "Handhelds usually transmit up to 5 or 6 watts and, with a low antenna, often reach only a few miles.",
     "Hills, buildings and large ships between stations reduce range."),
   H("Simplex and duplex"),
   T("Most ship-to-ship channels are simplex: both stations use the same frequency, so only one can talk at a time. Some channels used by coast stations are duplex, using two frequencies. Either way, you must release the transmit button to hear the reply."),
   TIP("1 nautical mile = 1,852 metres (about 1.15 statute miles). Marine radio and navigation always use nautical miles.")),
  lesson("basics-3", "Using the radio well", 4,
   H("The controls you will use"),
   L("Squelch: cuts background hiss. Turn it until the noise just stops; too far and you will miss weak stations.",
     "Dual watch: listens to Channel 16 and one other channel in turn. Tri-watch adds a third.",
     "16/9 key: jumps straight to Channel 16.",
     "High/low power switch.",
     "Distress button: under a cover, for DSC distress alerts only."),
   H("Good habits"),
   L("Listen before you transmit so you do not talk over someone.",
     "Think about what you will say, keep it short, and speak clearly at normal speed.",
     "Hold the microphone a few centimetres from your mouth and pause briefly after pressing the transmit button.",
     "Keep a radio log of distress, urgency and safety traffic you hear."),
   F("Why VHF, not a phone?", "A VHF call is heard by every station in range, including rescuers and nearby vessels. A phone call reaches one person."))
 ]},
 {"id": "procedure", "titleKey": "Channels & calling procedure", "symbol": "dial.medium", "lessons": [
  lesson("procedure-1", "Channels you must know", 5,
   F("Channel 16", "Distress, urgency, safety and calling. Keep a listening watch here whenever you are at sea."),
   F("Channel 70", "Digital Selective Calling only. Voice is never used on Channel 70."),
   L("Channel 6: the primary intership safety channel, also used for search and rescue coordination.",
     "Channel 13: navigation safety between ships (bridge-to-bridge).",
     "Common intership channels for routine chat include 8, 72 and 77, but check local practice.",
     "Port operations and marinas have their own published channels.",
     "Some coast stations move small craft to a specific safety working channel (in UK waters this is Channel 67)."),
   W("Channel 16 is not for chatting. Use it only to make contact, then move to a working channel."),
   TIP("Channel use differs between regions. US channel plans, for example, assign some channels differently. Always check the almanac or pilot for the area.")),
  lesson("procedure-2", "Making a routine call", 6,
   T("A routine call to another vessel has a set shape: who you are calling, who you are, and what you want, ending with OVER."),
   S("SEA OTTER, SEA OTTER", "THIS IS BLUE HERON, BLUE HERON", "CHANNEL 72", "OVER"),
   T("The other vessel replies and confirms the channel. Both switch to 72 and the conversation continues there:"),
   S("BLUE HERON, THIS IS SEA OTTER", "CHANNEL 72", "OVER"),
   L("Say the called station's name up to three times (once or twice is usually enough in good conditions), and your own up to three times.",
     "End each transmission with OVER when you expect a reply, and finish the conversation with OUT.",
     "Never say OVER and OUT together: one invites a reply, the other ends the exchange.",
     "If there is no answer, wait at least two minutes before calling again on Channel 16."),
   TIP("Give the working channel in your first call so that time on Channel 16 is kept to a minimum.")),
  lesson("procedure-3", "Coast stations and radio checks", 4,
   T("Coast stations include coastguard centres, port authorities and marinas. Call them on their published working channel, or on Channel 16 if that is what they advertise."),
   H("Radio checks"),
   T("A radio check asks another station how well your signal is received. Avoid using Channel 16 for radio checks. Use a working channel with another vessel or a marina, or a DSC test call where supported."),
   S("SEA OTTER, THIS IS BLUE HERON", "RADIO CHECK, CHANNEL 72", "OVER"),
   S("BLUE HERON, THIS IS SEA OTTER", "LOUD AND CLEAR", "OVER"),
   L("Signal reports often use words such as loud and clear, readable, weak, or broken.",
     "If you only caught part of a call, use STATION CALLING rather than guessing the name."))
 ]},
 {"id": "dsc", "titleKey": "DSC operation", "symbol": "dot.radiowaves.right", "lessons": [
  lesson("dsc-1", "MMSI and DSC basics", 5,
   T("Digital Selective Calling (DSC) sends a short digital message on Channel 70. It can alert every station in range, or ring a single vessel or coast station like a phone call. When the alert is a distress alert it carries your identity and, if connected to GPS, your position."),
   F("MMSI", "A nine-digit Maritime Mobile Service Identity, unique to the vessel's DSC equipment."),
   L("The first three digits of a ship's MMSI are the Maritime Identification Digits (MID), showing the country. UK ships, for example, use MIDs 232 to 235.",
     "Coast station MMSIs start with 00.",
     "Group MMSIs start with a single 0.",
     "The MMSI is issued with the ship radio licence and must be programmed into the radio. On most sets it can be entered only once."),
   W("Connect a working GPS feed to your DSC radio. Without it, a distress alert goes out with no position unless you enter one manually.")),
  lesson("dsc-2", "Sending a DSC distress alert", 6,
   T("A DSC distress alert is the fastest way to tell rescuers you are in grave and imminent danger."),
   L("Lift the cover over the red distress button.",
     "If there is time, choose the nature of distress from the menu (designated alert). If not, send an undesignated alert.",
     "Press and hold the button for about five seconds until the alert is sent.",
     "The radio switches itself to Channel 16. Wait briefly for an acknowledgement, then send your Mayday voice call.",
     "Until it is acknowledged, the radio repeats the alert automatically every few minutes."),
   H("If you receive a DSC distress alert"),
   L("Listen on Channel 16 for the voice Mayday and write down the details.",
     "Do not acknowledge by DSC. In coastal waters the coast station acknowledges.",
     "If no coast station answers and you can help, acknowledge by voice on Channel 16 and inform the coastguard by any means, including a Mayday relay.")),
  lesson("dsc-3", "Other DSC calls and false alerts", 5,
   H("Routine individual calls"),
   T("Enter the other vessel's MMSI, choose a working channel, and send. Their radio rings and, when they accept, both sets move to the working channel for the voice conversation."),
   H("Urgency and safety alerts"),
   T("An all-ships DSC urgency or safety alert announces that a Pan-Pan or Sécurité voice message is about to follow on Channel 16 or a stated working channel."),
   H("Cancelling a false alert"),
   T("If you send a distress alert by mistake, do not switch off. Cancel it using the radio's cancel function if there is one, then make a voice cancellation on Channel 16 straight away:"),
   S("ALL STATIONS, ALL STATIONS, ALL STATIONS", "THIS IS SEA OTTER, SEA OTTER, SEA OTTER", "CALL SIGN MIKE X-RAY YANKEE ZULU NINER", "MMSI TOO TREE FIFE ZERO ZERO ZERO ZERO ZERO ZERO", "POSITION 50°45'N 001°18'W", "CANCEL MY DISTRESS ALERT OF 15 NOVEMBER AT 1420 UTC", "SEA OTTER, MIKE X-RAY YANKEE ZULU NINER, MMSI TOO TREE FIFE ZERO ZERO ZERO ZERO ZERO ZERO", "OUT"),
   TIP("False alerts are common and rescuers are understanding. What matters is cancelling quickly."))
 ]},
 {"id": "distress", "titleKey": "Distress, urgency & safety", "symbol": "lifepreserver", "lessons": [
  lesson("distress-1", "The three priority signals", 4,
   F("MAYDAY", "Distress. A vessel, aircraft or person is in grave and imminent danger and needs immediate assistance."),
   F("PAN-PAN", "Urgency. An urgent message about the safety of a vessel or person, where danger is not yet grave and imminent."),
   F("SÉCURITÉ", "Safety. An important navigation or weather warning. Pronounced say-cure-ee-tay."),
   T("Distress traffic has absolute priority over everything else. Urgency comes next, then safety, then routine traffic."),
   TIP("Examples: sinking or fire out of control is a Mayday; a dismasted yacht drifting clear of danger, or a crew member needing medical advice, is a Pan-Pan; a floating container sighted in a shipping lane is a Sécurité.")),
  lesson("distress-2", "The Mayday call", 6,
   T("Use Mayday only when there is grave and imminent danger and immediate assistance is needed. Send a DSC distress alert first if you can, then make the voice call on Channel 16 on high power."),
   S("MAYDAY MAYDAY MAYDAY", "THIS IS SEA OTTER, SEA OTTER, SEA OTTER", "CALL SIGN MIKE X-RAY YANKEE ZULU NINER, MMSI TOO TREE FIFE ZERO ZERO ZERO ZERO ZERO ZERO", "MAYDAY SEA OTTER, MIKE X-RAY YANKEE ZULU NINER, MMSI TOO TREE FIFE ZERO ZERO ZERO ZERO ZERO ZERO", "MY POSITION IS 50°45'N 001°18'W", "FIRE ON BOARD, OUT OF CONTROL", "I REQUIRE IMMEDIATE ASSISTANCE", "3 PERSONS ON BOARD", "ABANDONING TO LIFERAFT", "OVER"),
   F("MIPDANIO", "Mayday, Identify, Position, Distress, Assistance, Number, Information, Over."),
   L("Give your position as latitude and longitude, or as a true bearing and distance from a charted point.",
     "Speak slowly. Rescuers need to write everything down.",
     "If nobody replies, repeat the call. Consider other channels or means if there is still no answer."),
   W("Never practise a Mayday on air. Use the practice builder in this app instead.")),
  lesson("distress-3", "Acknowledging, relaying and radio silence", 6,
   H("Acknowledging a Mayday"),
   T("If you hear a Mayday and no coast station answers, and you can help, acknowledge it:"),
   S("MAYDAY", "SEA OTTER, SEA OTTER, SEA OTTER", "THIS IS BLUE HERON, BLUE HERON, BLUE HERON", "RECEIVED MAYDAY", "OVER"),
   H("Mayday relay"),
   T("A Mayday relay passes a distress message on, for example when the casualty cannot be heard by the coastguard or you see distress flares."),
   S("MAYDAY RELAY, MAYDAY RELAY, MAYDAY RELAY", "THIS IS BLUE HERON, BLUE HERON, BLUE HERON", "FOLLOWING RECEIVED FROM SEA OTTER", "MAYDAY SEA OTTER ... (repeat the original message)", "OVER"),
   H("Radio silence"),
   L("SEELONCE MAYDAY: silence imposed by the station controlling distress traffic.",
     "SEELONCE DISTRESS: silence imposed by any other station near the incident.",
     "PRUDONCE: restricted working may resume.",
     "SEELONCE FEENEE: distress traffic is over and normal working may resume.")),
  lesson("distress-4", "Pan-Pan and Sécurité calls", 5,
   H("Pan-Pan"),
   S("PAN-PAN, PAN-PAN, PAN-PAN", "ALL STATIONS, ALL STATIONS, ALL STATIONS", "THIS IS BLUE HERON, BLUE HERON, BLUE HERON", "CALL SIGN BRAVO HOTEL ROMEO WUN, MMSI TOO TREE TREE ZERO ZERO ZERO ZERO ZERO ZERO", "MY POSITION IS 2 MILES SOUTH OF BLACK ROCK BUOY", "DISMASTED, ENGINE WILL NOT START, DRIFTING, NO IMMEDIATE DANGER", "REQUIRE TOW", "4 PERSONS ON BOARD", "OVER"),
   H("Sécurité"),
   T("Announce a safety message on Channel 16 and give a working channel for the full message, so that Channel 16 stays clear."),
   S("SÉCURITÉ, SÉCURITÉ, SÉCURITÉ", "ALL STATIONS, ALL STATIONS, ALL STATIONS", "THIS IS BLUE HERON, BLUE HERON, BLUE HERON", "LARGE PARTLY SUBMERGED CONTAINER SIGHTED", "POSITION 2 MILES EAST OF BLACK ROCK BUOY", "DANGER TO NAVIGATION", "OUT"),
   TIP("Coastguards also use Sécurité calls to announce weather and navigation warnings, usually telling listeners which channel to switch to."))
 ]},
 {"id": "gmdss", "titleKey": "GMDSS, EPIRB & SART", "symbol": "globe.europe.africa", "lessons": [
  lesson("gmdss-1", "GMDSS and sea areas", 5,
   T("The Global Maritime Distress and Safety System (GMDSS) is an international framework that combines radio, satellite and automated alerting so that a distress call is received ashore wherever a vessel is."),
   L("Sea Area A1: within range of a shore VHF DSC station, typically 20 to 30 nautical miles from the coast.",
     "Sea Area A2: within range of a shore MF DSC station, roughly 100 to 150 nautical miles, outside A1.",
     "Sea Area A3: within coverage of geostationary communication satellites, roughly 70°N to 70°S, outside A1 and A2.",
     "Sea Area A4: everything else, mainly the polar regions."),
   T("Leisure craft are not normally required to carry GMDSS equipment, but a DSC VHF radio means you are part of the system in coastal waters.")),
  lesson("gmdss-2", "EPIRBs, PLBs and SARTs", 6,
   F("EPIRB", "Emergency Position-Indicating Radio Beacon. Sends a 406 MHz satellite distress signal identifying the vessel, usually with a GNSS position."),
   L("EPIRBs also transmit a low-power 121.5 MHz homing signal so rescuers can find you on scene.",
     "They activate manually or, in a float-free bracket, automatically when submerged.",
     "Register your EPIRB with the national authority and keep the details up to date. Rescuers use the registration to find out who you are and who to contact.",
     "A PLB (Personal Locator Beacon) works on the same principle but is registered to a person and must be activated by hand."),
   F("SART", "Search and Rescue Transponder. Helps rescuers locate a liferaft at close range."),
   L("A radar SART responds to a 9 GHz (X-band) radar and shows as a line of 12 dots on the rescuer's radar screen, pointing out from your position.",
     "An AIS-SART transmits your position as an AIS message, displayed on AIS-equipped plotters.",
     "Mount a SART as high as possible in the liferaft to increase its detection range."),
   W("If you activate a beacon by accident, switch it off and tell the coastguard straight away.")),
  lesson("gmdss-3", "Maritime safety information", 4,
   T("Coast stations and coastguards broadcast weather forecasts, gale warnings and navigation warnings. These are known as Maritime Safety Information (MSI)."),
   L("VHF broadcasts are usually announced on Channel 16 and then read on a working channel.",
     "NAVTEX is an automated text service on 518 kHz (international, in English) and 490 kHz (often national language).",
     "Your almanac lists broadcast times and channels for each area."),
   TIP("Note the time and the working channel when you hear a broadcast announcement, then switch over to listen."))
 ]},
 {"id": "phonetics", "titleKey": "Phonetics & prowords", "symbol": "textformat.abc", "lessons": [
  lesson("phonetics-1", "The phonetic alphabet and numbers", 5,
   T("Letters and numbers are easy to mishear on the radio. The international phonetic alphabet removes doubt. Use it for call signs, vessel names that might be misheard, and anything that has to be spelled."),
   L("A ALFA, B BRAVO, C CHARLIE, D DELTA, E ECHO, F FOXTROT, G GOLF",
     "H HOTEL, I INDIA, J JULIETT, K KILO, L LIMA, M MIKE, N NOVEMBER",
     "O OSCAR, P PAPA, Q QUEBEC, R ROMEO, S SIERRA, T TANGO, U UNIFORM",
     "V VICTOR, W WHISKEY, X X-RAY, Y YANKEE, Z ZULU"),
   H("Numbers"),
   L("0 ZERO, 1 WUN, 2 TOO, 3 TREE, 4 FOW-ER", "5 FIFE, 6 SIX, 7 SEV-EN, 8 AIT, 9 NIN-ER"),
   T("Say each figure separately. An MMSI of 235 000 000 is spoken TOO TREE FIFE ZERO ZERO ZERO ZERO ZERO ZERO."),
   TIP("Practise with the Phonetic cards in Radio drills.")),
  lesson("phonetics-2", "Prowords", 5,
   T("Procedure words (prowords) are short, fixed phrases with an agreed meaning. They save time and avoid confusion, so use them exactly."),
   L("OVER: I have finished and expect a reply.",
     "OUT: end of working, no reply expected.",
     "RECEIVED: I have received your message.",
     "SAY AGAIN: please repeat. I SAY AGAIN: I am repeating.",
     "CORRECTION: I made an error, the correct version follows.",
     "I SPELL: the next word is spelled phonetically.",
     "WAIT: pause for a few seconds.",
     "ALL AFTER / ALL BEFORE: the part of the message after or before a stated word.",
     "STATION CALLING: I heard a call but not the caller's name."),
   W("Avoid casual radio slang such as 'Roger that, over and out'. It is not standard and can cause confusion.")),
  lesson("phonetics-3", "Time and position", 4,
   H("Time"),
   T("Use the 24-hour clock and, in distress and safety messages, Coordinated Universal Time (UTC). 2:20 pm UTC is said as ONE FOW-ER TOO ZERO UTC."),
   H("Position"),
   L("Latitude and longitude: degrees and minutes, latitude first, for example 50°45'N 001°18'W.",
     "Or a true bearing and distance from a charted point: 225 degrees true from Black Rock Buoy, 2 miles. The bearing is from the charted point to you."),
   F("Units at sea", "Distance in nautical miles (1 nautical mile = 1,852 m), speed in knots, bearings in degrees true."),
   TIP("Keep your position written down or visible near the radio so you can give it immediately."))
 ]}
]

course = {"version": 1, "modules": modules}

qs = []
def q(module, prompt, options, answer, explanation):
    qs.append({"id": f"{module}-{len([x for x in qs if x['module']==module])+1}", "module": module,
               "prompt": prompt, "options": options, "answer": answer, "explanation": explanation})

# basics
q("basics", "What does the operator's certificate cover?", ["The vessel's radio installation", "The person operating the radio", "The vessel's insurance", "Use of a mobile phone at sea"], 1, "The operator's certificate is personal. The installation is covered by a separate ship radio licence.")
q("basics", "Which factor most affects VHF range?", ["Transmitter power", "Antenna height", "Time of day", "Channel number"], 1, "VHF travels in nearly straight lines, so antenna height matters far more than power.")
q("basics", "Two antennas are each 4 m high. What is the approximate range?", ["4.5 nautical miles", "9 nautical miles", "18 nautical miles", "36 nautical miles"], 1, "2.25 × (√4 + √4) = 2.25 × 4 = 9 nautical miles.")
q("basics", "What is the maximum transmit power of a fixed marine VHF radio?", ["1 watt", "5 watts", "25 watts", "100 watts"], 2, "Fixed sets transmit up to 25 W, with a 1 W low-power setting for short-range use.")
q("basics", "What does the squelch control do?", ["Changes the channel", "Cuts background noise when no signal is present", "Increases transmit power", "Sends a DSC alert"], 1, "Set squelch so the hiss just disappears; too high and weak signals are lost.")
q("basics", "What does 'secrecy of correspondence' mean?", ["You must encrypt your calls", "You must not disclose or use traffic not intended for you", "You must not talk about your own position", "Calls may only be made in English"], 1, "You may hear other people's calls, but you must not repeat or use them. Distress, urgency and safety traffic are the exception.")
q("basics", "Why is VHF better than a mobile phone in an emergency?", ["It is cheaper", "Every station in range hears the call", "It works anywhere in the world", "It needs no battery"], 1, "A VHF call reaches rescuers and nearby vessels at once. A phone reaches one person.")
q("basics", "What does dual watch do?", ["Transmits on two channels at once", "Monitors Channel 16 and one other channel in turn", "Doubles the range", "Records calls"], 1, "Dual watch alternates between Channel 16 and a selected channel so you do not miss calls on 16.")

# procedure
q("procedure", "What is Channel 16 used for?", ["Routine conversation", "Distress, urgency, safety and calling", "DSC only", "Port operations only"], 1, "Make contact on 16, then move to a working channel.")
q("procedure", "Which channel is used only for DSC?", ["Channel 6", "Channel 13", "Channel 16", "Channel 70"], 3, "Channel 70 carries DSC data only. Voice is never used on it.")
q("procedure", "What is Channel 13 mainly used for?", ["Marina bookings", "Navigation safety between ships", "Weather forecasts", "DSC"], 1, "Channel 13 is for bridge-to-bridge navigation safety.")
q("procedure", "Which is the primary intership safety channel?", ["Channel 6", "Channel 9", "Channel 72", "Channel 70"], 0, "Channel 6 is for intership safety and search and rescue coordination, not routine chat.")
q("procedure", "How should you end a transmission when you expect a reply?", ["OUT", "OVER", "OVER AND OUT", "ROGER"], 1, "OVER invites a reply. OUT ends the exchange. Never combine them.")
q("procedure", "No reply to your routine call on Channel 16. How long should you wait before calling again?", ["10 seconds", "30 seconds", "At least 2 minutes", "15 minutes"], 2, "Waiting keeps Channel 16 clear and gives the other station time to respond.")
q("procedure", "Where should a radio check be made?", ["On Channel 16", "On a working channel, or by DSC test call where supported", "On Channel 70 by voice", "Only with the coastguard on 16"], 1, "Keep Channel 16 clear. Use a working channel or a DSC test call.")
q("procedure", "You heard a call for your vessel but not who was calling. What do you say?", ["SAY AGAIN", "STATION CALLING", "WHO IS THIS", "ALL STATIONS"], 1, "STATION CALLING is the correct proword when the caller's name was not heard.")

# dsc
q("dsc", "How many digits does an MMSI have?", ["7", "8", "9", "12"], 2, "An MMSI is always nine digits.")
q("dsc", "What do the first three digits of a ship's MMSI show?", ["The vessel type", "The country (Maritime Identification Digits)", "The year of licence", "The radio model"], 1, "The MID identifies the country. UK ships use 232 to 235.")
q("dsc", "A coast station MMSI begins with…", ["0", "00", "1", "9"], 1, "Coast stations start with 00. Group MMSIs start with a single 0.")
q("dsc", "How do you send a DSC distress alert?", ["Say MAYDAY on Channel 70", "Lift the cover and hold the distress button for about 5 seconds", "Press the 16/9 key twice", "Switch to high power"], 1, "Hold the red button for about five seconds. Choose the nature of distress first if time allows.")
q("dsc", "What happens after a DSC distress alert is sent?", ["The radio switches off", "The radio switches to Channel 16 and repeats the alert until acknowledged", "The radio waits on Channel 70 for a voice reply", "Nothing until you press again"], 1, "Wait briefly for acknowledgement, then send your voice Mayday on 16.")
q("dsc", "In coastal waters, how should another yacht respond to a DSC distress alert it receives?", ["Acknowledge by DSC immediately", "Listen on Channel 16 and leave acknowledgement to the coast station", "Switch off the radio", "Reply on Channel 70 by voice"], 1, "Coast stations acknowledge. Listen on 16 and be ready to help or relay.")
q("dsc", "You sent a DSC distress alert by mistake. What should you do?", ["Switch the radio off and say nothing", "Cancel on the radio if possible and make a voice cancellation on Channel 16", "Send a second alert", "Call the coastguard tomorrow"], 1, "Do not switch off. Cancel and announce the cancellation by voice on 16 straight away.")
q("dsc", "Why should a DSC radio be connected to GPS?", ["To improve audio", "So the distress alert includes your position", "To increase range", "It is needed to change channels"], 1, "Without a position feed, rescuers receive your identity but not where you are.")

# distress
q("distress", "When is a Mayday appropriate?", ["Engine failure in open water, no danger", "Grave and imminent danger needing immediate assistance", "To request a weather forecast", "A minor injury on board"], 1, "Mayday is for grave and imminent danger only.")
q("distress", "Which signal is used for an urgent message where danger is not yet grave and imminent?", ["MAYDAY", "PAN-PAN", "SÉCURITÉ", "SEELONCE"], 1, "PAN-PAN is the urgency signal.")
q("distress", "A floating container is drifting in a busy channel. Which signal fits?", ["MAYDAY", "PAN-PAN", "SÉCURITÉ", "MAYDAY RELAY"], 2, "SÉCURITÉ announces navigation and weather safety information.")
q("distress", "In the Mayday call, what follows the vessel's identification?", ["Number of persons on board", "Position", "OVER", "Nature of distress"], 1, "Order: Mayday, identify, position, nature, assistance, number, information, over.")
q("distress", "What does SEELONCE MAYDAY mean?", ["Distress is over", "Silence, imposed by the station controlling distress traffic", "Restricted working may resume", "Repeat your message"], 1, "Only the controlling station uses SEELONCE MAYDAY.")
q("distress", "Which proword means distress traffic has ended?", ["PRUDONCE", "SEELONCE DISTRESS", "SEELONCE FEENEE", "OUT"], 2, "SEELONCE FEENEE: normal working may resume.")
q("distress", "When would you send a MAYDAY RELAY?", ["When you are in distress yourself", "When passing on a distress message the coastguard may not have received", "To cancel a false alert", "To ask for a radio check"], 1, "A relay passes on another vessel's distress, for example when the casualty is out of the coastguard's range.")
q("distress", "How should a Sécurité message be handled on Channel 16?", ["Read the whole message on 16", "Announce on 16 and give a working channel for the full message", "Send it only by DSC", "Wait for permission from the coastguard"], 1, "Keep 16 clear by moving the full message to a working channel.")
q("distress", "What does PRUDONCE mean?", ["Total silence", "Restricted working may resume", "Distress is over", "Speak more slowly"], 1, "PRUDONCE allows restricted working during distress traffic.")

# gmdss
q("gmdss", "Sea Area A1 is defined by coverage of…", ["MF DSC shore stations", "VHF DSC shore stations", "Geostationary satellites", "NAVTEX"], 1, "A1 is within range of a shore VHF DSC station, typically 20 to 30 nautical miles.")
q("gmdss", "On what frequency does an EPIRB send its satellite distress signal?", ["121.5 MHz", "156.8 MHz", "406 MHz", "518 kHz"], 2, "406 MHz goes to satellites. 121.5 MHz is for homing.")
q("gmdss", "Why must an EPIRB be registered?", ["To make it work", "So rescuers know whose beacon it is and who to contact", "To increase battery life", "It is optional and unimportant"], 1, "Registration links the beacon to your vessel and emergency contacts.")
q("gmdss", "How does a radar SART appear on a rescuer's radar?", ["A flashing circle", "A line of 12 dots", "A single bright spot", "The vessel's name"], 1, "A radar SART shows as 12 dots extending outwards from your position.")
q("gmdss", "What should you do if you activate a beacon by accident?", ["Leave it on", "Switch it off and tell the coastguard straight away", "Throw it overboard", "Remove the battery and say nothing"], 1, "Switching off and informing the coastguard prevents a needless search.")
q("gmdss", "On what frequency is international NAVTEX broadcast in English?", ["490 kHz", "518 kHz", "156.525 MHz", "406 MHz"], 1, "518 kHz carries the international service in English. 490 kHz is often national language.")
q("gmdss", "How is a PLB different from an EPIRB?", ["It uses Channel 16", "It is registered to a person and activated by hand", "It has no satellite signal", "It only works in harbour"], 1, "A PLB is personal and manually activated.")

# phonetics
q("phonetics", "How is the letter J spelled phonetically?", ["JULIET", "JULIETT", "JAMES", "JOKER"], 1, "The ITU spelling is JULIETT with two Ts.")
q("phonetics", "How should the number 9 be spoken?", ["NINE", "NIN-ER", "NEIN", "NINETY"], 1, "NIN-ER avoids confusion with the German 'nein'.")
q("phonetics", "Which proword means 'I have finished and expect a reply'?", ["OUT", "OVER", "WAIT", "RECEIVED"], 1, "OVER invites a reply.")
q("phonetics", "Which proword asks the other station to repeat?", ["I SAY AGAIN", "SAY AGAIN", "CORRECTION", "ALL AFTER"], 1, "SAY AGAIN means please repeat. I SAY AGAIN is used when you repeat.")
q("phonetics", "Which time standard is used in distress and safety messages?", ["Local time", "UTC", "Ship's time", "Time of the nearest port"], 1, "Use the 24-hour clock in UTC.")
q("phonetics", "What is 1 nautical mile in metres?", ["1,000 m", "1,609 m", "1,852 m", "2,000 m"], 2, "1 nautical mile = 1,852 metres.")
q("phonetics", "A position given as a bearing and distance uses a bearing…", ["Magnetic, from you to the point", "True, from the charted point to you", "Relative to your bow", "In compass points"], 1, "Bearings are given in degrees true, from the charted point to your position.")

(out / "course.json").write_text(json.dumps(course, ensure_ascii=False, indent=1))
(out / "questions.json").write_text(json.dumps({"version": 1, "questions": qs}, ensure_ascii=False, indent=1))
print(len(modules), "modules,", sum(len(m["lessons"]) for m in modules), "lessons,", len(qs), "questions")
from collections import Counter; print(Counter(x["module"] for x in qs))
